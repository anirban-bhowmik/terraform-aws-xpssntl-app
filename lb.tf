module "lb" {
  source                   = "github.com/traveloka/terraform-aws-alb-single-listener?ref=v0.2.2"
  service_name             = "${local.service_name}"
  cluster_role             = "${var.cluster_role}"
  environment              = "${var.environment}"
  product_domain           = "${local.product_domain}"
  description              = "Application Load Balancer for ${local.service_name}"
  vpc_id                   = "${var.vpc_id}"
  lb_subnet_ids            = "${var.lb_subnet_ids}"
  lb_internal              = "${var.lb_internal}"
  lb_security_groups       = ["${aws_security_group.lb.id}", "${var.additional_lb_sg_ids}"]
  listener_certificate_arn = "${var.certificate_arn}"
  lb_logs_s3_bucket_name   = "${var.lb_logs_s3_bucket_name}"
  tg_target_type           = "ip"
  tg_port                  = "${local.service_port}"
  lb_idle_timeout          = "${local.lb_idle_timeout}"
  tg_health_check          = "${local.lb_tg_health_check}"

  tg_stickiness  =   {
          type           = "lb_cookie"
          enabled        = false
  }
}
