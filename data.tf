data "aws_region" "current" {}

data "aws_route53_zone" "record" {
  zone_id      = "${var.route53_zone_id}"
}

// Service Linked Role
data "aws_iam_role" "autoscaling" {
  name         = "AWSServiceRoleForApplicationAutoScaling_ECSService"
}

data "aws_iam_policy_document" "kms_policy" {
  statement {
    sid       = "AllowDecryptSSM"
    effect    = "Allow"
    actions   = ["kms:Decrypt"]
    resources = ["${var.kms_ssm_key_arn}"]
  }
}

data "aws_iam_policy_document" "this" {
  statement {
    sid    = "CrossAccountAllowPull"
    effect = "Allow"

    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetRepositoryPolicy",
      "ecr:DescribeRepositories",
      "ecr:ListImages",
      "ecr:DescribeImages",
      "ecr:BatchGetImage"
    ]

    principals {
      type        = "AWS"
      identifiers = "${var.ecr_cross_account_id}"
    }
  }
}

data "template_file" "events" {

  template = "${file("${path.module}/events-role-policy.json")}"

  vars = {
    codepipeline_arn = "${aws_codepipeline.this.arn}"
  }
}

data "template_file" "ecr_event" {

  template = "${file("${path.module}/ecr-source-event.json")}"

  vars = {
    ecr_repository_name = "${module.ecr.name}"
  }
}