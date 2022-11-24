output "task_definition_arn" {
  value = aws_ecs_task_definition.ecs_task_def.arn
}

output "task_definition_revision" {
  value = aws_ecs_task_definition.ecs_task_def.revision
}
