// ----------------------------------------------
// Service
// ----------------------------------------------
module "app_sg_name" {
  source        = "github.com/traveloka/terraform-aws-resource-naming?ref=v0.17.0"
  name_prefix   = "${local.service_name}-app"
  resource_type = "security_group"
}

resource "aws_security_group" "app" {
  name        = "${module.app_sg_name.name}"
  description = "Security group for ${local.service_name}-app"
  vpc_id      = "${var.vpc_id}"

  tags = {
    Name          = "${module.app_sg_name.name}"
    Service       = "${local.service_name}"
    ProductDomain = "${local.product_domain}"
    Environment   = "${var.environment}"
    Description   = "Security group for ${local.service_name}-app"
    ManagedBy     = "terraform"
  }
}

resource "aws_security_group_rule" "egress_app_to_all_https" {
  type        = "egress"
  from_port   = "443"
  to_port     = "443"
  protocol    = "tcp"

  security_group_id = "${aws_security_group.app.id}"
  cidr_blocks       = ["0.0.0.0/0"]

}

resource "aws_security_group_rule" "egress_app_to_all_http" {
  type        = "egress"
  from_port   = "80"
  to_port     = "80"
  protocol    = "tcp"

  security_group_id = "${aws_security_group.app.id}"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "ingress_app_from_lb" {
  type        = "ingress"
  from_port   = "${local.service_port}"
  to_port     = "${local.service_port}"
  protocol    = "tcp"

  security_group_id        = "${aws_security_group.app.id}"
  source_security_group_id = "${aws_security_group.lb.id}"
}

// ----------------------------------------------
// Load Balancer
// ----------------------------------------------
module "lb_sg_name" {
  source        = "github.com/traveloka/terraform-aws-resource-naming?ref=v0.17.0"
  name_prefix   = "${local.service_name}-lb"
  resource_type = "security_group"
}

resource "aws_security_group" "lb" {
  name        = "${module.lb_sg_name.name}"
  description = "Security group for ${local.service_name}-lb"
  vpc_id      = "${var.vpc_id}"

  tags = {
    Name          = "${module.lb_sg_name.name}"
    Service       = "${local.service_name}"
    ProductDomain = "${local.product_domain}"
    Environment   = "${var.environment}"
    Description   = "Security group for ${local.service_name}-lb"
    ManagedBy     = "terraform"
  }
}

resource "aws_security_group_rule" "egress_lb_to_app" {
  type                     = "egress"
  from_port                = "${local.service_port}"
  to_port                  = "${local.service_port}"
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.lb.id}"
  source_security_group_id = "${aws_security_group.app.id}"
}