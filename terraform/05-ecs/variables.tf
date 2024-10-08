variable "aws_region" {
  description = "AWS region where the Network resources will be deployed, e.g., 'us-east-1' for the North Ameria (US) region"
  type = string
  default = "us-east-1"
}

variable "environment" {
  description = "Deploy enviroment name, such as 'dev', 'test', 'prod'. This categorizes the Network resources by their usage stage"
  type = string
  default = "dev"
}

variable "service_name" {
  description = "The name of the service the bastion host is associated with, used for naming and tagging resources in AWS"
  type = string
  default = "lazzy"
}

variable "department_name" {
  description = "Name of the department responsible for the VPC, e.g., 'engineering', 'marketing'. Helps in identifying ownership of the resources"
  type = string
  default = "engineering"
}

variable "ecs" {
  description = "Configuration object for the ECS services, including CPU/memory allocations, app container port, desired count of tasks, Docker image URL, and health check path"
  
  type = object({
    fargate_cpu = number
    fargate_memory = number
    app_port = number
    app_count = number
    app_image = string
    health_check_path = string
  })

  default = {
    fargate_cpu = 256
    fargate_memory = 512
    app_port = 3000
    app_count = 1
    app_image = ""
    health_check_path = "/healthcheck"
  }
}

variable "ecs_redis" {
  description = "Configuration object for the ECS redis services, including CPU/memory allocations, app container port, desired count of tasks, Docker image URL, and health check path"
  
  type = object({
    fargate_cpu = number
    fargate_memory = number
    app_port = number
    app_count = number
    app_image = string
  })

  default = {
    fargate_cpu = 256
    fargate_memory = 512
    app_port = 6379
    app_count = 1
    app_image = "redis:latest"
  }
}

variable "log_level" {
  description = "Defines the logging level for the application, affecting the verbosity of logs, e.g, 'info', 'debug'"
  type = string
  default = "info"
}

variable "log_retention_days" {
  description = "Specifies the duration in days that logs are retained in CloudWatch before being deleted, e.g., '5' days"
  type = number
  default = 5
}

variable "autoscaling" {
  description = "Autoscaling parameters for the ECS service, detailing minimum and maximum tasks counts, along with rules for autoscaling based on CPU, memory usage, and ALB requests counts"
  type = object({
    min_capacity = number
    max_capacity = number

    memory_autoscaling = object({
      target = number
      scale_in_cooldown = number
      scale_out_cooldown = number
    })

    cpu_autoscaling = object({
      target = number
      scale_in_cooldown = number
      scale_out_cooldown = number
    })

    alb_autoscaling = object({
      target = number
    })
  })
  default = {
    min_capacity = 1
    max_capacity = 10
    memory_autoscaling = {
      target = 60
      scale_in_cooldown = 300
      scale_out_cooldown = 300
    }
    cpu_autoscaling = {
      target = 40
      scale_in_cooldown = 300
      scale_out_cooldown = 300
    }
    alb_autoscaling = {
      target = 100
    }
  }
}

variable "domain_name" {
  type = string
  description = "Optional. The apx domain name for creating a subdomain for the service. Must be a valid domain format, e.g., 'example.com'"
  default = null

  validation {
    condition = var.domain_name != null ? can(regex("^[a-zA-Z0-9][a-zA-Z0-9-]{1, 61}[a-zA-Z0-9].[a-zA-Z]{2,}$", var.domain_name)) : true
    error_message = "Invalid domain name. It must be a valid domain name"
  }
}

variable "redis_node_type" {
  description = "The compute and memory capacity of the nodes in the node group"
  type        = string
  default     = "cache.t4g.micro"
}

variable "redis_num_cache_clusters" {
  description = "The number of cache clusters (primary and replicas) this replication group will have"
  type        = number
  default     = 1
}

variable "redis_engine_version" {
  description = "The version of the Redis engine to use"
  type        = string
  default     = "7.0"
}

variable "redis_port" {
  description = "The port number on which each of the cache nodes will accept connections"
  type        = number
  default     = 6379
}