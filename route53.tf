resource "aws_route53_record" "dns" {
  zone_id                  = "${var.route53_zone_id}"
  name                     = "${local.service_name}.${data.aws_route53_zone.record.name}"
  type                     = "A"
  alias {
    name                   = "${lower(module.lb.lb_dns)}"
    zone_id                = "${module.lb.lb_zone_id}"
    evaluate_target_health = true
  }
}
