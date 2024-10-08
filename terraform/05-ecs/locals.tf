locals {
  namespaced_service_name = "${var.service_name}-${var.environment}"
  namespaced_department_name = "${var.department_name}-${var.environment}"

  account_id = data.aws_caller_identity.current.account_id

  # ECS - main
  container_name = "${local.namespaced_service_name}-container-main"
  app_image = var.ecs.app_image != "" ? var.ecs.app_image : "${data.terraform_remote_state.ecr.outputs.repository_url}:${data.terraform_remote_state.ecr.outputs.version}"

  # ECS - redis
  container_name_redis = "${local.namespaced_service_name}-container-redis"
  app_image_redis = var.ecs.app_image != "" ? var.ecs.app_image : "redis:alpine"

  # Network
  vpc = data.terraform_remote_state.network.outputs.vpc
  subnets = data.terraform_remote_state.network.outputs.subnets

  autoscaling_resource_id = "service/${aws_ecs_cluster.this.name}/${aws_ecs_service.this.name}"

  # Database
  db_name = data.terraform_remote_state.db.outputs.database_name
  db_host = data.terraform_remote_state.db.outputs.database_endpoint
  db_user = data.terraform_remote_state.db.outputs.database_username
  db_port = data.terraform_remote_state.db.outputs.database_port
  db_pass = jsondecode(data.aws_secretsmanager_secret_version.rds_password.secret_string)["password"]

  # Domain
  is_prod_env = var.environment == "prod"
  has_domain_name = var.domain_name != null
  create_resource_based_on_domain_name = local.has_domain_name ? 1 : 0
  subdomain_name = local.has_domain_name ? "${local.is_prod_env ? "" : "${var.environment}."}fargate.${var.domain_name}" : ""

  common_tags = {
    Project = "Teste AWS ECS Fargate com Terraform"
    Component = "ECS Fargate"
    CreatedAt = "2024-07-03"
    ManagedBy = "Terraform"
    Owner = "Caio Couto"
    Env = var.environment
    Repository = "https://github.com/caio-couto/lazzy"
  }
}