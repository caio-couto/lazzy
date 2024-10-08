resource "aws_appautoscaling_target" "this" {
  max_capacity = var.autoscaling.max_capacity
  min_capacity = var.autoscaling.min_capacity
  resource_id = local.autoscaling_resource_id
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace = "ecs"
}

resource "aws_appautoscaling_policy" "ecs_policy_memory" {
  name = "memory-autoscaling"
  policy_type = "TargetTrackingScaling"
  resource_id = aws_appautoscaling_target.this.resource_id
  scalable_dimension = aws_appautoscaling_target.this.scalable_dimension
  service_namespace = aws_appautoscaling_target.this.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }

    target_value = var.autoscaling.memory_autoscaling.target 
    scale_in_cooldown = var.autoscaling.memory_autoscaling.scale_in_cooldown
    scale_out_cooldown = var.autoscaling.memory_autoscaling.scale_out_cooldown
  }
}

resource "aws_appautoscaling_policy" "ecs_policy_cpu" {
  name = "cpu-autoscaling"
  policy_type = "TargetTrackingScaling"
  resource_id = aws_appautoscaling_target.this.resource_id
  scalable_dimension = aws_appautoscaling_target.this.scalable_dimension
  service_namespace = aws_appautoscaling_target.this.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value = var.autoscaling.cpu_autoscaling.target 
    scale_in_cooldown = var.autoscaling.cpu_autoscaling.scale_in_cooldown
    scale_out_cooldown = var.autoscaling.cpu_autoscaling.scale_out_cooldown
  }
}

resource "aws_appautoscaling_policy" "ecs_policy_alb_request_count" {
  name = "alb-request-count-autoscaling"
  policy_type = "TargetTrackingScaling"
  resource_id = aws_appautoscaling_target.this.resource_id
  scalable_dimension = aws_appautoscaling_target.this.scalable_dimension
  service_namespace = aws_appautoscaling_target.this.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ALBRequestCountPerTarget"
      resource_label = "${aws_alb.this.arn_suffix}/${aws_alb_target_group.this.arn_suffix}"
    }

    target_value = var.autoscaling.alb_autoscaling.target
  }
}