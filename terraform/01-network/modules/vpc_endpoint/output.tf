output "endpoint_s3" {
  value = {
    id = aws_vpc_endpoint.s3.id
    arn = aws_vpc_endpoint.s3.arn
    state = aws_vpc_endpoint.s3.state
  }
}

output "endpoint_logs" {
  value = {
    id = aws_vpc_endpoint.logs.id
    arn = aws_vpc_endpoint.logs.arn
    state = aws_vpc_endpoint.logs.state
  }
}

output "endpoint_ecr_dkr" {
  value = {
    id = aws_vpc_endpoint.ecr_dkr_endpoint.id
    arn = aws_vpc_endpoint.ecr_dkr_endpoint.arn
    state = aws_vpc_endpoint.ecr_dkr_endpoint.state
  }
}

output "endpoint_ecr_api" {
  value = {
    id = aws_vpc_endpoint.ecr_api_endpoint.id
    arn = aws_vpc_endpoint.ecr_api_endpoint.arn
    state = aws_vpc_endpoint.ecr_api_endpoint.state
  }
}