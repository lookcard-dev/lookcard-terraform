resource "aws_ecs_task_definition" "xray_daemon" {
  family                   = "XRayDaemon"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.xray_ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.xray_ecs_task_execution_role.arn
  cpu                      = "256"
  memory                   = "512"

  container_definitions = jsonencode([
    {
      name      = "xray-daemon"
      image     = "amazon/aws-xray-daemon"
      essential = true
      portMappings = [
        {
          containerPort = 2000
          protocol      = "udp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-create-group"  = "true",
          "awslogs-group"         = "/ecs/XRayDaemon"
          "awslogs-region"        = "ap-southeast-1"
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])
}

resource "aws_cloudwatch_log_group" "xray_daemon" {
  name = "/ecs/XRayDaemon"
}