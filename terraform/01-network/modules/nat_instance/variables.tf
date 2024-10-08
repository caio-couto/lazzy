variable "env" {
  description = "Designate the deployment environment (e.g., 'dev', 'test', 'prod'). This value can be used to differentiate resources across deployment stages."
  type = string
  default = "dev"
}

variable "vpc_id" {
  description = "Specifies the ID of the VPC where NAT intances will be deployed, ensuring network connectivity for resources within this VPC"
  type = string
}

variable "vpc_name" {
  description = "Provides a default name for the VPC associated with NAT Instances, aiding in resources identification and organization."
  type = string
  default = "terraform-vpc"
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs where NAT instances will be placed, facilitanting outbound internet access for private subnets."
  type = list(string)
}

variable "nat_instance_count" {
  description = "Determines how many NAT instances to create, supporting a balance between availability and cost. Valid range: 1 to 3"
  type = number
  default = 2

  validation {
    condition = var.nat_instance_count > 0 && var.nat_instance_count < 4
    error_message = "nat_instance_count must be greeter than 0 and lesser than 4"
  }
}

variable "nat_instance_type" {
  description = "Defines the EC2 instance type used for NAT instances, optimized for cost-effectiveness. Default is 't4g.nano' for lightweight workloads"
  type = string
  default = "t4g.nano"
}