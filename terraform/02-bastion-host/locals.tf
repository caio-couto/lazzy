locals {
  namespaced_service_name = "${var.service_name}-${var.environment}"

  # Network
  vpc = data.terraform_remote_state.network.outputs.vpc
  subnets = data.terraform_remote_state.network.outputs.subnets

  common_tags = {
    Project = "Teste AWS ECS Fargate com Terraform"
    Component = "Bastion-host"
    CreatedAt = "2024-07-03"
    ManagedBy = "Terraform"
    Owner = "Caio Couto"
    Env = var.environment
    Repository = "https://github.com/caio-couto/lazzy"
  }
}