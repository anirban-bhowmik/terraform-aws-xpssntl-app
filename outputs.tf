output "app_sg_id" {
  value       = "${aws_security_group.app.id}"
}

output "lb_sg_id" {
  value       = "${aws_security_group.lb.id}"
}

output "lb_fqdn" {
  value       = "${aws_route53_record.dns.fqdn}"
}

output "ecs_service_name" {
  value       = "${module.fargate.service_name}"
}

output "scale_up_policy_arn" {
  description = "ARN of the scale up policy."
  value       = "${join("", aws_appautoscaling_policy.up.*.arn)}"
}

output "scale_down_policy_arn" {
  description = "ARN of the scale down policy."
  value       = "${join("", aws_appautoscaling_policy.down.*.arn)}"
}

output "lb_dns" {
  value       = "${module.lb.lb_dns}"
  description = "The DNS name of the load balancer"
}

output "lb_zone_id" {
  value       = "${module.lb.lb_zone_id}"
  description = "The canonical hosted zone ID of the load balancer (to be used in a Route 53 Alias record)"
}

output "lb_arn" {
  value       = "${module.lb.lb_arn}"
  description = "The ARN of the ALB"
}

output "lb_arn_suffix" {
  value       = "${module.lb.lb_arn_suffix}"
  description = "The ARN suffix of the ALB, useful with CloudWatch Metrics"
}

output "tg_arn" {
  value       = "${module.lb.tg_arn}"
  description = "The arn of the default target group"
}

output "tg_arn_suffix" {
  value       = "${module.lb.tg_arn_suffix}"
  description = "The arn suffix of the default target group, useful with CloudWatch Metrics"
}

output "ecr_arn" {
  value       = "${module.ecr.arn}"
  description = "Full ARN of the repository."
}

output "ecr_name" {
  value       = "${module.ecr.name}"
  description = "The name of the repository."
}

output "ecr_registry_id" {
  value       = "${module.ecr.registry_id}"
  description = "The registry ID where the repository was created."
}

output "ecr_repository_url" {
  value       = "${module.ecr.repository_url}"
  description = "The URL of the repository "
}

output "ecs_role_name" {
  description = "The name of the role."
  value       = "${module.task_role.role_name}"
}

output "ecs_role_arn" {
  description = "The Amazon Resource Name (ARN) specifying the role."
  value       = "${module.task_role.role_arn}"
}

output "ecs_role_description" {
  description = "The description of the role."
  value       = "${module.task_role.role_description}"
}

output "ecs_role_unique_id" {
  description = "The stable and unique string identifying the role."
  value       = "${module.task_role.role_unique_id}"
}