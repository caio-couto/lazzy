resource "aws_security_group" "this" {
  name = "${local.namespaced_service_name}-redis"
  description = "Redis instance security group"
  vpc_id = local.vpc.id

  ingress {
    from_port = 6379
    to_port = 6379
    protocol = "tcp"
    cidr_blocks = local.subnets.private.cidr_blocks
  }

  tags = {
    "Name" = local.namespaced_service_name
  }
}

resource "aws_elasticache_subnet_group" "this" {
    name = local.namespaced_service_name
    subnet_ids = local.subnets.private.id 

    tags = {
      Name = "${local.namespaced_service_name}-redis"
    }
}

resource "aws_elasticache_replication_group" "this" {
  replication_group_id = "${local.namespaced_service_name}-redis"
  description = "Redis replication group for lynk API and worker"
  automatic_failover_enabled = false
  node_type = var.redis_node_type
  num_cache_clusters = var.redis_num_cache_clusters
  engine = "redis"
  engine_version = var.redis_engine_version
  subnet_group_name = aws_elasticache_subnet_group.this.name
  security_group_ids = [aws_security_group.this.id]
  port  = var.redis_port
}
