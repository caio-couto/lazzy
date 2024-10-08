resource "aws_cloudwatch_log_group" "this" {
  name = "/ecs/${local.namespaced_service_name}"
  retention_in_days = var.log_retention_days

  tags = {
    Name = local.namespaced_service_name
  }
}