variable "app_domain" {
  type = string
}

variable "aws_region" {
  type    = string
  default = "eu-west-1"
}

variable "ecr_repository_uri" {
  type    = string
  default = ""
}

variable "ecs_alb_arn" {
  type    = string
  default = "arn:aws:elasticloadbalancing:eu-west-1:325427326730:loadbalancer/app/stolets-ecs-lb/d95774f79e41b4a2"
}

variable "ecs_alb_listener_arn" {
  type    = string
  default = "arn:aws:elasticloadbalancing:eu-west-1:325427326730:listener/app/stolets-ecs-lb/d95774f79e41b4a2/3753617598a5276b"
}

variable "ecs_cluster_arn" {
  type    = string
  default = "arn:aws:ecs:eu-west-1:325427326730:cluster/stolets-production-cluster"
}

variable "ecs_image_tag" {
  type    = string
  default = "latest"
}

variable "ecs_s3_env_bucket_arn" {
  type    = string
  default = "arn:aws:s3:::stolets-ecs-env-vars-bucket"
}

# variable "ecs_service_discovery_namespace_id" {
#   type    = string
#   default = "ns-aehhdhywidwtixjc"
# }

variable "ecs_service_security_groups" {
  type    = list(string)
  default = ["sg-0f4fe44f56a3c9a37"]
}

variable "ecs_service_subnets" {
  type    = list(string)
  default = ["subnet-0b253d244cefb5e12", "subnet-029ea5f873616713a", "subnet-098953d175939531c"]
}


variable "ecs_task_execution_role_arn" {
  type    = string
  default = "arn:aws:iam::325427326730:role/ecs_task_execution_role"
}

variable "ecs_vpc_id" {
  type    = string
  default = "vpc-0df2d2d1b7655ac7c"
}

variable "environment" {
  type    = string
  default = "staging"
}

variable "organization_name" {
  type    = string
  default = "stolets"
}

variable "project_name" {
  type = string
}
