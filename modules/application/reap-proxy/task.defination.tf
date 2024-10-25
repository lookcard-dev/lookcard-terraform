resource "aws_ecs_task_definition" "reap_proxy" {
  family             = local.application.name
  network_mode       = "awsvpc"
  cpu                = "256"
  memory             = "512"
  task_role_arn      = aws_iam_role.reap_proxy_task_role.arn
  execution_role_arn = aws_iam_role.reap_proxy_task_execution_role.arn
  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }

  container_definitions = jsonencode([
    {
      name  = local.application.name
      image = "${local.application.image}:${local.application.image_tag}"
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-group = "/ecs/${local.application.name}",
          awslogs-create-group = "true",
          awslogs-region = "ap-southeast-1",
          awslogs-stream-prefix = "nginx"
        }
        # logDriver = "awsfirelens",
        # options = {
        #   "bucket" : "scott-temp-testing-reap-proxy",
        #   "total_file_size" : "1M",
        #   "use_put_object" : "On",
        #   "upload_timeout" : "1m",
        #   "region" : "ap-southeast-1",
        #   "Name" : "s3",
        #   "retry_limit" : "2"
        # }
      }
      secrets     = local.ecs_task_secret_vars
      environment = local.ecs_task_env_vars
      portMappings = [
        {
          name          = "reap-proxy-8080-tcp",
          containerPort = local.application.port,
          hostPort      = local.application.port,
          protocol      = "tcp",
          appProtocol   = "http",
        },
      ]      
      healthCheck = {
        command     = ["CMD-SHELL", "curl -f http://localhost:${local.application.port}/healthcheckz || exit 1"]
        interval    = 30 # seconds between health checks
        timeout     = 5  # health check timeout in seconds
        retries     = 3  # number of retries before marking container unhealthy
        startPeriod = 10 # time to wait before performing first health check
      }
    },
    {
      name = "log_router",
      image = "amazon/aws-for-fluent-bit:stable",
      essential = true,
      user = "0",
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-group = "/ecs/${local.application.name}",
          awslogs-create-group = "true",
          awslogs-region = "ap-southeast-1",
          awslogs-stream-prefix = "firelens"
        }
      }
      # firelensConfiguration = {
      #   type = "fluentbit"
      # }
    }
  ])
}
