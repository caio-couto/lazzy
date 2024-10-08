output "cluster" {
  value = {
    name = aws_ecs_cluster.this.name
    arn = aws_ecs_cluster.this.arn
  }
}

output "task_definition" {
  value = {
    arn = aws_ecs_task_definition.this.arn
    version = aws_ecs_task_definition.this.revision
  }
}

output "redis_endpoint" {
  description = "The endpoint of the Redis replication group"
  value       = aws_elasticache_replication_group.this.primary_endpoint_address
}

output "alb_url" {
  value = aws_alb.this.dns_name
}

output "log_group" {
  value = aws_cloudwatch_log_group.this.arn
}

output "api_url" {
  value = local.has_domain_name ? "https://${aws_route53_record.api[0].name}" : "http://${aws_alb.this.dns_name}"
}