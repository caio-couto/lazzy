use_nat_gateway = false
use_nat_instance = false
create_vpc_endpoint = true
network = {
  az_count = 2
  cidr_block = "10.1.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
}