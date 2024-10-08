output "database_endpoint" {
  value = aws_rds_cluster.postgres.endpoint
}

output "database_name" {
  value = var.db_name
}

output "database_username" {
  value = var.db_user
}

output "database_port" {
  value = aws_rds_cluster.postgres.port
}

output "database_kms_key_id" {
  value = aws_kms_key.this.key_id
}

output "database_kms_key_arn" {
  value = aws_kms_key.this.arn
}


output "database_password_secret" {
  value = aws_rds_cluster.postgres.master_user_secret
}