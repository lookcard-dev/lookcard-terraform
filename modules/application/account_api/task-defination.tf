data "aws_ecr_image" "latest" {
  repository_name = "account-api"
  most_recent     = true
}


resource "aws_ecs_task_definition" "Account_API" {
  family                   = "Account-API"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  task_role_arn            = aws_iam_role.Account_API_Task_Role.arn
  execution_role_arn       = aws_iam_role.Account_API_Task_Execution_Role.arn
  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }
  volume {
    name = "data"
  }

  container_definitions = jsonencode([
    {
      name  = "Account-API"
      image = data.aws_ecr_image.latest.image_uri
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          "awslogs-create-group"  = "true",
          "awslogs-group"         = "/ecs/Account-API",
          "awslogs-region"        = "ap-southeast-1",
          "awslogs-stream-prefix" = "ecs",
        }
      }
      secrets = [
         {
          name          = "DATABASE_URL"
          valueFrom     = "${var.crypto_api_secret_arn}:DATABASE_URL::"
        },
        {
          name          = "FIREBASE_PROJECT_ID"
          valueFrom     = "${var.firebase_secret_arn}:PROJECT_ID::"
        },
        {
          name          = "FIREBASE_SERVICE_ACCOUNT_PRIVATE_KEY"
          valueFrom     = "${var.firebase_secret_arn}:SERVICE_ACCOUNT_PRIVATE_KEY::"
        },
         {
          name          = "FIREBASE_SERVICE_ACCOUNT_CLIENT_EMAIL"
          valueFrom     = "${var.firebase_secret_arn}:SERVICE_ACCOUNT_CLIENT_EMAIL::"
        },
        {
          name          = "FIREBASE_CREDENTIALS"
          valueFrom     = "${var.firebase_secret_arn}:CREDENTIALS::"
        },
         {
          name          = "API_KEY"
          valueFrom     = "${var.elliptic_secret_arn}:API_KEY::"
        },
        {
          name          = "API_SECRET"
          valueFrom     = "${var.elliptic_secret_arn}:API_SECRET::"
        },
         {
          name          = "DATABASE_ENDPOINT"
          valueFrom     = "${var.db_secret_secret_arn}:host::"
        },
        {
          name          = "DATABASE_USERNAME"
          valueFrom     = "${var.db_secret_secret_arn}:username::"
        },
        {
          name          = "DATABASE_PASSWORD"
          valueFrom     = "${var.db_secret_secret_arn}:password::"
        }
      ]
      environment = [
        {
          name  = "CRYPTO_API_URL"
          value = "https://api.test.lookcard.io"
        },
        {
          name  = "DATABASE_NAME"
          value = "main"
        },
        {
          name  = "SQS_NOTIFICATION_QUEUE_URL"
          value = var.lookcard_notification_sqs_url
        },
        {
          name  = "SQS_ACCOUNT_WITHDRAWAL_QUEUE_URL"
          value = var.crypto_fund_withdrawal_sqs_url
        }
      ]
      portMappings = [
        {
          name          = "look-card-account-api-8080-tcp",
          containerPort = 8080,
          hostPort      = 8080,
          protocol      = "tcp",
          appProtocol   = "http",
        },
      ]
      readonlyRootFilesystem : true
      mountPoints = [
        {
          sourceVolume  = "data",
          containerPath = "/usr/src/data",
        },
      ]
    }
  ])
}

resource "aws_cloudwatch_log_group" "Account_API" {
  name = "/ecs/Account-API"

}


resource "aws_security_group" "Account-API-SG" {
  depends_on  = [var.vpc_id]
  name        = "Account-API-Service-Security-Group"
  description = "Security group for Account API services"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Account-API-Security-Group"
  }
}
