# ---------------------------------------------------------------------------------------------------------------------
# AWS ECS Task Execution Role
# ---------------------------------------------------------------------------------------------------------------------
module "task_role" {
  source = "github.com/traveloka/terraform-aws-iam-role.git//modules/service?ref=v1.0.2"
  role_identifier            = "${local.service_name}-TaskRole"
  role_description           = "Service Role for ECS Task"
  role_force_detach_policies = false
  aws_service                = "ecs-tasks.amazonaws.com"
  product_domain             = "${local.product_domain}"
  environment                = "${var.environment}"
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = "${module.task_role.role_name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
}

resource "aws_iam_role_policy" "kms" {
  role   = "${module.task_role.role_name}"
  policy = "${data.aws_iam_policy_document.kms_policy.json}"
}

module "codepipeline_role" {
  source = "github.com/traveloka/terraform-aws-iam-role.git//modules/service?ref=v1.0.2"
  role_identifier            = "${local.service_name}-codepipeline"
  role_description           = "Service Role for ECS CodePipeline"
  role_force_detach_policies = true
  role_max_session_duration  = 43200
  aws_service                = "codepipeline.amazonaws.com"
  product_domain             = "${local.product_domain}"
  environment                = "${var.environment}"
}

resource "aws_iam_role_policy" "codepipeline" {
  role   = "${module.codepipeline_role.role_name}"
  policy = "${var.codepipeline_iam_policy}"
}

module "events_role" {
  source = "github.com/traveloka/terraform-aws-iam-role.git//modules/service?ref=v1.0.2"
  role_identifier            = "${local.service_name}-events-role"
  role_description           = "Service Role for CodePipeline Events"
  role_force_detach_policies = true
  role_max_session_duration  = 43200
  aws_service                = "events.amazonaws.com"
  product_domain             = "${local.product_domain}"
  environment                = "${var.environment}"
}

resource "aws_iam_role_policy" "events" {
  role   = "${module.events_role.role_name}"
  policy = "${data.template_file.events.rendered}"
}