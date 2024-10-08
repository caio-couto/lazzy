resource "aws_ecs_cluster" "this" {
  name = local.namespaced_department_name

  setting {
    name = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_task_definition" "this" {
  family = local.namespaced_service_name
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn = aws_iam_role.ecs_task_role.arn
  requires_compatibilities = [ "FARGATE" ]
  network_mode = "awsvpc"
  cpu = var.ecs.fargate_cpu
  memory = var.ecs.fargate_memory
  skip_destroy = true
  container_definitions = jsonencode([{
    name = local.container_name
    image = local.app_image
    localConfiguration = {
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          "awslogs-group" = "/ecs/${local.namespaced_service_name}",
          "awslogs-region" = var.aws_region,
          "awslogs-stream-prefix" = "ecs",
        }
      }
    }

    portMappings = [{
      containerPort = var.ecs.app_port
      hostPort = var.ecs.app_port
    }]

    environment = [
      {
        name = "ENV"
        value = var.environment
      },
      {
        name = "APP_NAME"
        value = local.namespaced_service_name
      },
      {
        name = "PORT"
        value = tostring(var.ecs.app_port)
      },
      {
        name = "LOG_LEVEL"
        value = var.log_level
      },
      {
        name = "AWS_REGION"
        value = var.aws_region
      },
      {
        name = "DATABASE_URL"
        value = "postgresql://${local.db_user}:${urlencode(local.db_pass)}@${local.db_host}:${local.db_port}/${local.db_name}"
      },
      {
        name = "AWS_NODEJS_CONNECTION_REUSE_ENABLED"
        value = "1"
      }
    ]
  }])
}

resource "aws_ecs_service" "this" {
  name = "${local.namespaced_service_name}-service"
  cluster = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.this.arn
  desired_count = var.ecs.app_count
  launch_type = "FARGATE"
  health_check_grace_period_seconds = 30

  network_configuration {
    subnets = local.subnets.private.id
    security_groups = [ aws_security_group.ecs_tasks.id ]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.this.id
    container_name = local.container_name
    container_port = var.ecs.app_port
  }

  depends_on = [ aws_alb_listener.http ]

  # desired_count is ignored as it can change due autoscaling policy
  lifecycle {
    ignore_changes = [ desired_count ]
  }
}