resource "aws_security_group" "alb" {
  name = "${local.namespaced_department_name}-alb"
  description = "Controls access to the ALB"
  vpc_id = local.vpc.id

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.namespaced_service_name}-alb"
  }
}

resource "aws_security_group" "ecs_tasks" {
  name = "${local.namespaced_department_name}-ecs-tasks"
  description = "Controls access to the ECS tasks"
  vpc_id = local.vpc.id

  ingress {
    from_port = var.ecs.app_port
    to_port = var.ecs.app_port
    protocol = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.namespaced_service_name}-ecs-tasks"
  }
}