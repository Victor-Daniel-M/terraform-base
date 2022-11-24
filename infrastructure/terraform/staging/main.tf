module "ecs" {
  source = "../modules/aws/ecs"

  organization_name  = var.organization_name
  project_name       = var.project_name
  aws_region         = var.aws_region
  ecr_repository_uri = var.ecr_repository_uri

  environment           = var.environment
  app_domain            = var.app_domain
  ecs_alb_arn           = var.ecs_alb_arn
  ecs_alb_listener_arn  = var.ecs_alb_listener_arn
  ecs_cluster_arn       = var.ecs_cluster_arn
  ecs_image_tag         = var.ecs_image_tag
  ecs_s3_env_bucket_arn = var.ecs_s3_env_bucket_arn
  # ecs_service_discovery_namespace_id = var.ecs_service_discovery_namespace_id
  ecs_service_security_groups = var.ecs_service_security_groups
  ecs_service_subnets         = var.ecs_service_subnets
  ecs_task_execution_role_arn = var.ecs_task_execution_role_arn
  ecs_vpc_id                  = var.ecs_vpc_id
}
