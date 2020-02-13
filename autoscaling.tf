# ---------------------------------------------------------------------------------------------------------------------
# AWS Auto Scaling - Scaling Target
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_appautoscaling_target" "default" {
    resource_id        = "service/${var.ecs_cluster_name}/${module.fargate.service_name}"
    service_namespace  = "ecs"
    scalable_dimension = "ecs:service:DesiredCount"
    role_arn           = "${data.aws_iam_role.autoscaling.arn}"
    min_capacity       = "${var.min_capacity}"
    max_capacity       = "${var.max_capacity}"
}

resource "aws_appautoscaling_policy" "up" {
    name                    = "${module.fargate.service_name}-cpu-scale-up-policy"
    resource_id             = "${aws_appautoscaling_target.default.resource_id}"
    scalable_dimension      = "ecs:service:DesiredCount"
    service_namespace       = "ecs"

    step_scaling_policy_configuration {
        adjustment_type         = "ChangeInCapacity"
        cooldown                = "${var.scale_up_cooldown}"
        metric_aggregation_type = "Average"

        step_adjustment {
            metric_interval_lower_bound = 0
            scaling_adjustment = "${var.scale_up_adjustment}"
        }
    }
    depends_on = ["aws_appautoscaling_target.default"]
}

resource "aws_appautoscaling_policy" "down" {
    name                    = "${module.fargate.service_name}-cpu-scale-down-policy"
    resource_id             = "${aws_appautoscaling_target.default.resource_id}"
    scalable_dimension      = "ecs:service:DesiredCount"
    service_namespace       = "ecs"

    step_scaling_policy_configuration {
        adjustment_type         = "ChangeInCapacity"
        cooldown                = "${var.scale_down_cooldown}"
        metric_aggregation_type = "Average"

        step_adjustment {
            metric_interval_upper_bound = 0
            scaling_adjustment = "${var.scale_down_adjustment}"
        }
    }

    depends_on = ["aws_appautoscaling_target.default"]
}

# A CloudWatch alarm that monitors cpu usage of containers for scaling up
resource "aws_cloudwatch_metric_alarm" "service_cpu_usage_high" {
    alarm_name              = "${module.fargate.service_name}-cpu-usage-above-${var.cpu_usage_high_threshold}"
    alarm_description       = "This alarm monitors ${module.fargate.service_name} cpu usage for scaling up"
    comparison_operator     = "GreaterThanOrEqualToThreshold"
    evaluation_periods      = "${var.cpu_usage_high_evaluation_periods}"
    metric_name             = "CPUUtilization"
    namespace               = "AWS/ECS"
    period                  = "${var.cpu_usage_high_period}"
    statistic               = "${var.statistic_type}"
    threshold               = "${var.cpu_usage_high_threshold}"
    alarm_actions           = ["${aws_appautoscaling_policy.up.arn}"]

    dimensions {
        ServiceName           = "${module.fargate.service_name}"
        ClusterName           = "${var.ecs_cluster_name}"
    }
}

# A CloudWatch alarm that monitors cpu usage of containers for scaling down
resource "aws_cloudwatch_metric_alarm" "service_cpu_usage_low" {
    alarm_name              = "${module.fargate.service_name}-cpu-usage-below-${var.cpu_usage_low_threshold}"
    alarm_description       = "This alarm monitors ${module.fargate.service_name} cpu usage for scaling down"
    comparison_operator     = "LessThanOrEqualToThreshold"
    evaluation_periods      = "${var.cpu_usage_low_evaluation_periods}"
    metric_name             = "CPUUtilization"
    namespace               = "AWS/ECS"
    period                  = "${var.cpu_usage_low_period}"
    statistic               = "${var.statistic_type}"
    threshold               = "${var.cpu_usage_low_threshold}"
    alarm_actions           = ["${aws_appautoscaling_policy.down.arn}"]

    dimensions {
        ServiceName           = "${module.fargate.service_name}"
        ClusterName           = "${var.ecs_cluster_name}"
    }
}
