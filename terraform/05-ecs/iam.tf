# ecs_task_execution_role
# This role is necessary for the CES agent to start and run tasks on your behalf

data "aws_iam_policy_document" "ecs_task_execution_role" {
  version = "2012-10-17"

  statement {
    sid = ""
    effect = "Allow"
    actions = [ "sts:AssumeRole" ]
    principals {
      type = "Service"
      identifiers = [ "ecs-tasks.amazonaws.com" ]
    }
  }
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${var.service_name}-task-execution-${var.environment}"

  assume_role_policy = data.aws_iam_policy_document.ecs_task_execution_role.json
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role" {
  role = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# ecs_task_role
# This role is necessary fot the task themselves to perform actions on AWS services

resource "aws_iam_role" "ecs_task_role" {
  name = "${var.service_name}-task-${var.environment}"

  assume_role_policy = data.aws_iam_policy_document.ecs_task_execution_role.json
}

resource "aws_iam_policy" "ecs_task_role" {
  name = "${var.service_name}-task-${var.environment}"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = "rds:*"
      Resource = "arn:aws:rds:${var.aws_region}:${local.account_id}:/table/${local.db_name}"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_role" {
  role = aws_iam_role.ecs_task_role.name 

  policy_arn = aws_iam_policy.ecs_task_role.arn
}