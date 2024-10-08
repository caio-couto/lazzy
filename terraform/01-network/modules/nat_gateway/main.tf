locals {
  az_codes = ["a", "b", "c"]
}

resource "aws_eip" "this" {
  count = var.az_count
  domain = "vpc"
}

resource "aws_nat_gateway" "this" {
  count = var.az_count

  subnet_id = var.public_subnet_ids[count.index]
  allocation_id = aws_eip.this.*.id[count.index]

  tags = {
    "Name" = "${var.vpc_name}-az-${local.az_codes[count.index]}"
  }
}