variable "region" {
  type = "string"
}

variable "environment" {
  type        = "string"
  description = "The environment this stack belongs to"
  default     = "development"
}

variable "cluster_role" {
  description = "The role of the cluster in the service"
  type        = "string"
  default     = "app"
}

variable "container_name" {
  type        = "string"
  description = "The name of the container. Up to 255 characters ([a-z], [A-Z], [0-9], -, _ allowed)"
  default     = "app"
}

variable "container_image_version" {
  type        = "string"
  description = "The image version used to start the container. Images in the Docker Hub registry available by default"
  default     = "latest"
}

variable "ecs_cluster_arn" {
  type        = "string"
  description = "ECS Cluster ARN"
}

variable "deployment_controller_type" {
  description = "Type of deployment controller. Valid values: `CODE_DEPLOY`, `ECS`."
  default     = "ECS"
}

variable "desired_count" {
  description = "The number of instances of the task definition to place and keep running"
  default     = 1
}

variable "vpc_id" {
  type        = "string"
  description = "The ID of the VPC this stack belongs to"
}

variable "subnet_ids" {
  description = "List of IDs of subnets to launch the service in"
  type        = "list"
}

variable "lb_subnet_ids" {
  type        = "list"
  description = "The list of subnet ids to attach to the LB"
}

variable "certificate_arn" {
  type        = "string"
  description = "The ARN of the default SSL server certificate"
}

variable "lb_logs_s3_bucket_name" {
  type        = "string"
  description = "The s3 bucket where the LB access logs will be stored"
}

variable "route53_zone_id" {
  type        = "string"
  description = "The ID of Route 53 zone"
}

variable "kms_ssm_key_arn" {
  type    = "string"
}

variable "container_profile_name" {
  type        = "string"
}

variable "task_cpu" {
  description = "Number of cpu units to allocate for one task"
  type        = "string"
  default     = "256"
}

variable "task_memory" {
  description = "Amount of memory (in MiB) to allocate for one task"
  type        = "string"
  default     = "512"
}

variable "min_capacity" {
  type        = "string"
  description = "Minimum number of running instances of a Service."
  default     = "1"
}

variable "max_capacity" {
  type        = "string"
  description = "Maximum number of running instances of a Service."
  default     = "2"
}

variable "health_check_grace_period_seconds" {
  description = "Seconds to ignore failing load balancer health checks on newly instantiated tasks to prevent premature shutdown."
  type        = "string"
  default     = 0
}

variable "cpu_usage_high_threshold" {
  default = 80
}
variable "cpu_usage_high_evaluation_periods" {
  default = 5
}
variable "cpu_usage_high_period" {
  default = 300
}
variable "cpu_usage_low_threshold" {
  default = 10
}
variable "cpu_usage_low_evaluation_periods" {
  default = 3
}
variable "cpu_usage_low_period" {
  default = 300
}
variable "statistic_type" {
  default = "Average"
}
variable "scale_up_adjustment" {
  type        = "string"
  description = "Scaling adjustment to make during scale up event."
  default     = "1"
}

variable "scale_up_cooldown" {
  type        = "string"
  description = "Period (in seconds) to wait between scale up events."
  default     = "60"
}

variable "scale_down_adjustment" {
  type        = "string"
  description = "Scaling adjustment to make during scale down event."
  default     = "-1"
}

variable "scale_down_cooldown" {
  type        = "string"
  description = "Period (in seconds) to wait between scale down events."
  default     = "300"
}

variable "codepipeline_iam_policy" {
  type        = "string"
  description = "IAM policy for CodePipeline"
}

variable "codepipeline_artifact_bucket" {
  type        = "string"
  description = "An S3 bucket to be used as CodePipeline's artifact bucket"
}

variable "codepipeline_ecr_image_tag" {
  type        = "string"
  default     = "latest"
  description = "ECR Image Tag"
}

variable "codepipeline_codebuild_project_name" {
  type = "string"
  description = "CodeBuild Project Name for CodePipeline"
}

variable "ecs_cluster_name" {
  type        = "string"
  description = "ECS Cluster Name"
}

variable "ecr_cross_account_id" {
  type        = "list"
  default     = []
  description = "ECR Cross Account ID"
}

variable "lb_internal" {
  type        = "string"
  default     = true
  description = "Whether the LB will be public / private"
}

variable "additional_lb_sg_ids" {
  type    = "list"
  default = []
}

variable "ecs_tg_arn" {
  type        = "string"
  description = "ALB TargetGroup ARN"
}