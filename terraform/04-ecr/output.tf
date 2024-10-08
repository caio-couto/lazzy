output "arn" {
  description = "The ARN of the ECR Respository"
  value = aws_ecr_repository.this.arn 
}

output "name" {
  description = "The Name of the ECR Repository"
  value = aws_ecr_repository.this.name
}

output "repository_url" {
  description = "The URL of the ECR Repository"
  value = aws_ecr_repository.this.repository_url
}

output "version" {
  description = "The URL of the ECR Repository"
  value = random_id.version.id
}


output "repository_id" {
  description = "The Registry ID of the ECR Repository"
  value = aws_ecr_repository.this.registry_id
}