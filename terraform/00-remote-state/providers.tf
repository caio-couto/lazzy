provider "aws" {
  region = "us-east-1"
  profile = "test-terraform-ecs-deploy"

  default_tags {
    tags = {
      Project = "Teste AWS ECS Fargate com Terraform"
      Component = "Remote State"
      CreatedAt = "2024-07-03"
      ManagedBy = "Terraform"
      Owner = "Caio Couto"
      Repository = "https://github.com/caio-couto/lazzy"
    }
  }
}