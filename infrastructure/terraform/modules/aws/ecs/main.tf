locals {
  application_port = 3000
}

# Create a listener rule that routes requests to the target group
resource "aws_lb_listener_rule" "static" {
  listener_arn = var.ecs_alb_listener_arn

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.ecs_alb_target_group.arn
  }

  condition {
    host_header {
      values = [var.app_domain]
    }
  }
}

# Create the target group for the service
resource "aws_alb_target_group" "ecs_alb_target_group" {
  name        = substr(format("%s-%s-%s-%s", substr(var.project_name, 0, 5), var.environment, substr(uuid(), 0, 3), "tg"), 0, 32)
  port        = local.application_port
  protocol    = "HTTP"
  vpc_id      = var.ecs_vpc_id
  target_type = "ip"

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    unhealthy_threshold = "2"
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [name]
  }
}

# Create the task definition
resource "aws_ecs_task_definition" "ecs_task_def" {
  family = format("%s-%s-%s", var.project_name, var.environment, "td")
  container_definitions = jsonencode([
    {
      name : format("%s-%s-%s", var.project_name, var.environment, "container"),
      image : format("%s:%s", var.ecr_repository_uri, var.ecs_image_tag),
      essential : true,
      portMappings : [
        {
          "containerPort" : local.application_port,
          "hostPort" : local.application_port
        }
      ],
      environmentFiles : [
        {
          "type" : "s3",
          "value" : format("%s/%s/%s/%s", var.ecs_s3_env_bucket_arn, var.project_name, var.environment, "vars.env")
        }
      ],
      logConfiguration : {
        "logDriver" : "awslogs",
        "options" : {
          "awslogs-create-group" : "true",
          "awslogs-group" : format("%s-%s-%s", var.project_name, var.environment, "td"),
          "awslogs-region" : var.aws_region,
          "awslogs-stream-prefix" : "ecs"
        }
      },
    },
  ])
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  memory                   = 1024
  cpu                      = 512
  execution_role_arn       = var.ecs_task_execution_role_arn

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
}

# Create a service discovery name for the service
# resource "aws_service_discovery_service" "ecs_service_discovery" {
#   name = format("%s-%s", var.project_name, var.environment)

#   dns_config {
#     namespace_id   = var.ecs_service_discovery_namespace_id
#     routing_policy = "MULTIVALUE"
#     dns_records {
#       ttl  = 300
#       type = "A"
#     }
#   }

#   health_check_custom_config {
#     failure_threshold = 5
#   }
# }

# Create the service
resource "aws_ecs_service" "ecs_service" {
  name                               = format("%s-%s-%s", var.project_name, var.environment, "service")
  cluster                            = var.ecs_cluster_arn
  task_definition                    = aws_ecs_task_definition.ecs_task_def.arn
  desired_count                      = 1
  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200
  platform_version                   = "1.4.0"
  launch_type                        = "FARGATE"
  scheduling_strategy                = "REPLICA"

  network_configuration {
    security_groups  = var.ecs_service_security_groups
    subnets          = var.ecs_service_subnets
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.ecs_alb_target_group.arn
    container_name   = format("%s-%s-%s", var.project_name, var.environment, "container")
    container_port   = local.application_port
  }

  # service_registries {
  #   registry_arn = aws_service_discovery_service.ecs_service_discovery.arn
  # }
}
