provider "aws" {
  region = var.aws_region
  profile = "test-terraform-ecs-deploy"
  
  default_tags {
    tags = local.common_tags
  }
}