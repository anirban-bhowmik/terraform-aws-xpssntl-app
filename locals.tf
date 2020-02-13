locals {
  service_name            = "xpssntl"
  product_domain          = "xps"
  service_port            = 8080
  application             = "java"
  lb_idle_timeout         = 30

  lb_tg_health_check = {
    port             = "${local.service_port}"
    path             = "/actuator/health"
  }

  container_environment = [
    {
      name             = "PROFILE_NAME"
      value            = "${var.container_profile_name}"
    },
  ]

  port_mappings = [
    {
      containerPort    = "${local.service_port}"
      hostPort         = "${local.service_port}"
      protocol         = "tcp"
    },
  ]

  ecs_load_balancers = [
    {
      target_group_arn = "${var.ecs_tg_arn}"
      container_name   = "${var.container_name}"
      container_port   = "${local.service_port}"
    },
  ]
}
