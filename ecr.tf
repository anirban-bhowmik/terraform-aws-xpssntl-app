module "ecr" {
  source = "github.com/traveloka/terraform-aws-ecr-repository?ref=v0.1.0"

  repo_name         = "${local.service_name}"
  product_domain    = "${local.product_domain}"
  environment       = "${var.environment}"
  repository_policy = "${data.aws_iam_policy_document.this.json}"
  lifecyle_policy   = "${file("${path.module}/lifecycle-policy.json")}"
}