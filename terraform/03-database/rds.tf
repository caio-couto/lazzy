resource "aws_security_group" "this" {
  name = "${local.namespaced_service_name}-postgres"
  
  description = "Allow incoming database connections" 
  vpc_id = local.vpc.id

  ingress {
    from_port = 5432
    to_port = 5432
    protocol = "tcp"
    cidr_blocks = local.subnets.private.cidr_blocks
  }

  dynamic "ingress" {
    for_each = local.bastion_host_sg_id != "" ? [1] : []

    content {
      from_port = 5432
      to_port = 5432
      protocol = "tcp"
      security_groups = [local.bastion_host_sg_id]
    }
  }

  tags = {
    Name = "${local.namespaced_service_name}-postgres"
  }
}

resource "aws_db_subnet_group" "this" {
  name = local.namespaced_service_name
  subnet_ids = local.subnets.private.id 

  tags = {
    Name = "${local.namespaced_service_name}-postgres"
  }
}

resource "aws_rds_cluster" "postgres" {
  cluster_identifier = "${local.namespaced_service_name}-cluster"
  engine = var.db_engine.engine
  engine_version = var.db_engine.version
  availability_zones = local.availability_zones
  database_name = var.db_name
  master_username = var.db_user
  manage_master_user_password = true
  master_user_secret_kms_key_id = aws_kms_key.this.id
  backup_retention_period = var.db_backup_retention
  skip_final_snapshot = var.db_skip_final_snapshot

  kms_key_id = aws_kms_key.this.arn
  storage_encrypted = true 

  db_subnet_group_name = aws_db_subnet_group.this.id 
  vpc_security_group_ids = [aws_security_group.this.id]
}

resource "aws_rds_cluster_instance" "cluster_instance" {
  count = var.az_count

  identifier = "${local.namespaced_service_name}-${count.index}"
  cluster_identifier = aws_rds_cluster.postgres.id
  instance_class = var.db_machine
  engine = aws_rds_cluster.postgres.engine
  engine_version = aws_rds_cluster.postgres.engine_version
  publicly_accessible = var.db_public_acessible
  performance_insights_enabled = true
  performance_insights_kms_key_id = aws_kms_key.this.arn
}
