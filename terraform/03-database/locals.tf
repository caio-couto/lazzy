locals {
  namespaced_service_name = "${var.service_name}-${var.environment}"

  # Network
  vpc = data.terraform_remote_state.network.outputs.vpc
  subnets = data.terraform_remote_state.network.outputs.subnets
  availability_zones = data.terraform_remote_state.network.outputs.selected_availability_zones

  # Bastion Host
  bastion_host_sg_id = lookup(data.terraform_remote_state.bastion_host.outputs, "security_group_id", "")

  common_tags = {
    Project = "Teste AWS ECS Fargate com Terraform"
    Component = "Database"
    CreatedAt = "2024-07-03"
    ManagedBy = "Terraform"
    Owner = "Caio Couto"
    Env = var.environment
    Repository = "https://github.com/caio-couto/lazzy"
  }
}