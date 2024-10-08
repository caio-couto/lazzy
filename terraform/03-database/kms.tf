resource "aws_kms_key" "this" {
  description = "KMS key for the RDS"
  deletion_window_in_days = 7
  is_enabled = true 
  enable_key_rotation = true 

  tags = {
    Name = local.namespaced_service_name
  }
}