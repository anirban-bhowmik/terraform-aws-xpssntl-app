resource "aws_codepipeline" "this" {
  name     = "${local.service_name}-ecs-pipeline"
  role_arn = "${module.codepipeline_role.role_arn}"

  artifact_store {
    location = "${var.codepipeline_artifact_bucket}"
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "ECR"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration {
        RepositoryName = "${module.ecr.name}"
        ImageTag       = "${var.codepipeline_ecr_image_tag}"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name     = "Build"
      category = "Build"
      owner    = "AWS"
      provider = "CodeBuild"
      version  = "1"

      input_artifacts  = ["source_output"]
      output_artifacts = ["imagedefinitions"]

      configuration {
        ProjectName = "${var.codepipeline_codebuild_project_name}"
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ECS"
      input_artifacts = ["imagedefinitions"]
      version         = "1"

      configuration {
        ClusterName = "${var.ecs_cluster_name}"
        ServiceName = "${module.fargate.service_name}"
        FileName    = "imagedefinitions.json"
      }
    }
  }
}

resource "aws_cloudwatch_event_rule" "events" {
  name          = "${local.service_name}-ecr-event"
  description   = "Amazon CloudWatch Events rule to automatically start your pipeline when a change occurs in the Amazon ECR image tag."
  event_pattern = "${data.template_file.ecr_event.rendered}"
  depends_on    = ["aws_codepipeline.this"]
}

resource "aws_cloudwatch_event_target" "events" {
  rule      = "${aws_cloudwatch_event_rule.events.name}"
  target_id = "${local.service_name}-ecs-codepipeline"
  arn       = "${aws_codepipeline.this.arn}"
  role_arn  = "${module.events_role.role_arn}"
}