data "aws_caller_identity" "current" {}

data "terraform_remote_state" "network" {
  backend = "s3"

  config = {
    bucket = "tfstate-2024-${data.aws_caller_identity.current.account_id}"
    key = "lazzy/${var.environment}/network/terraform.tfstate"
    region = var.aws_region
  }
}

data "terraform_remote_state" "ecr" {
  backend = "s3"

  config = {
    bucket = "tfstate-2024-${data.aws_caller_identity.current.account_id}"
    key = "lazzy/${var.environment}/ecr/terraform.tfstate"
    region = var.aws_region
  }
}

data "terraform_remote_state" "db" {
  backend = "s3"

  config = {
    bucket = "tfstate-2024-${data.aws_caller_identity.current.account_id}"
    key = "lazzy/${var.environment}/database/terraform.tfstate"
    region = var.aws_region
  }
}

data "aws_secretsmanager_secret" "rds_password" {
  arn = data.terraform_remote_state.db.outputs.database_password_secret[0].secret_arn
}

data "aws_secretsmanager_secret_version" "rds_password" {
  secret_id = data.aws_secretsmanager_secret.rds_password.id
}