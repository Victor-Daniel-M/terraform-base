variable "app_domain" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "ecs_alb_arn" {
  type = string
}

variable "ecs_alb_listener_arn" {
  type = string
}

variable "ecs_cluster_arn" {
  type = string
}

variable "ecs_image_tag" {
  type = string
}

variable "ecr_repository_uri" {
  type = string
}

variable "ecs_s3_env_bucket_arn" {
  type = string
}

# variable "ecs_service_discovery_namespace_id" {
#   type = string
# }

variable "ecs_service_security_groups" {
  type = list(string)
}

variable "ecs_service_subnets" {
  type = list(string)
}

variable "ecs_task_execution_role_arn" {
  type = string
}

variable "ecs_vpc_id" {
  type = string
}

variable "environment" {
  type = string
}

variable "organization_name" {
  type = string
}

variable "project_name" {
  type = string
}
