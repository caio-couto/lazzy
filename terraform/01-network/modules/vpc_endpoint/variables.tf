variable "aws_region" {
  description = "AWS region where the Network resources will be deployed, e.g., 'us-east-1' for the North Ameria (US) region."
  type = string
}

variable "vpc_id" {
  description = "Unique identifier of the VPC where NAT instances will be created, linking these instances to a specific virtual network."
  type = string
}

variable "vpc_name" {
  description = "Assigns a name to the VPC associated whit NAT instances, faciliting easier identification. Defaults to 'terraform-vpc'."
  type = string
  default = "terraform-vpc"
}

variable "cidr_block" {
  description = "The CIDR block fot the VPC, defining its IP addrss range. Example format: '10.0.0.0/16"
  type = string
}

variable "private_route_table_ids" {
  description = "List of IDs for the private route tables within the VPC, used for routing decisions within private subnets."
  type = list(string)
}

variable "private_subnets_ids" {
  description = "List of IDs for the private subnets within the VPC, where internal resources without direct internet access are placed."
  type = list(string)
}