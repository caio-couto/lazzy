variable "vpc_name" {
  description = "Name of the VPC where the NAT Gateways will be created. this name is used to associate the NAT Gateways with a specific VPC in your AWS account."
  type = string
}

variable "az_count" {
  description = "Specifies the number of Availability Zones across which the NAT Gateways should be deployed. Valid values range from 1 to 3, inclusive, to balance cost and high availability."
  type = number
  validation {
    condition = var.az_count > 0 && var.az_count < 4
    error_message = "az_count must be greater than 0 and lesser than 4"
  }
}

variable "public_subnet_ids" {
  description = "A list of IDs for the public subnets where NAT Gateways will be placed. Each NAT Gateway id deployed into a separate subnet specified in this list."
  type = list(string)
}