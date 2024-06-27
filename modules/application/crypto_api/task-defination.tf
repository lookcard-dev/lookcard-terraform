data "aws_ecr_image" "latest" {
  repository_name = "crypto-api"
  most_recent     = true
}


resource "aws_security_group" "crypto-api-sg" {
  depends_on  = [var.network]
  name        = "crypto-api-service-security-group"
  description = "Security group for Crypto API services"
  vpc_id      = var.network.vpc

  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    # cidr_blocks = [var.sg_alb_id]
    # security_groups = [aws_security_group.ALB_SG.id, aws_security_group.Lambda_Aggregator_Tron_SG.id, aws_security_group.Transaction-Listener-SG.id, aws_security_group.Account-API-SG.id, aws_security_group.Crypto_Fund_Withdrawal_SG.id]
  }

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    # security_groups = [aws_security_group.ALB_SG.id, aws_security_group.Lambda_Aggregator_Tron_SG.id, aws_security_group.Transaction-Listener-SG.id, aws_security_group.Account-API-SG.id, aws_security_group.Crypto_Fund_Withdrawal_SG.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "crypto-api-security-group"
  }
}


resource "aws_ecs_task_definition" "crypto-api" {
  family                   = "crypto-api"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  task_role_arn            = aws_iam_role.crypto_api_task_role.arn
  execution_role_arn       = aws_iam_role.crypto_api_task_execution_role.arn
  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }
  volume {
    name = "data"
  }

  container_definitions = jsonencode([
    {
      name  = "crypto-api"
      image = data.aws_ecr_image.latest.image_uri
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          "awslogs-create-group"  = "true",
          "awslogs-group"         = "/ecs/crypto-api",
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
          name          = "FIREBASE_CREDENTIALS"
          valueFrom     = "${var.firebase_secret_arn}:CREDENTIALS::"
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
          name  = "AWS_REGION"
          value = "ap-southeast-1"
        },
        {
          name  = "KMS_GENERATOR_KEY_ID"
          value = "arn:aws:kms:ap-southeast-1:576293270682:key/6a28f5b4-2996-486e-8d24-bbf3a44031d0"
        },
        {
          name  = "KMS_ENCRYPTION_KEY_ID_A"
          value = "arn:aws:kms:ap-southeast-1:576293270682:key/f83d712a-19fc-4932-9b98-9e40b7984f16"
        },
        {
          name  = "DATABASE_NAME"
          value = "main"
        }
      ]
      portMappings = [
        {
          name          = "look-card-crypto-api-8080-tcp",
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
resource "aws_cloudwatch_log_group" "crypto_api" {
  name = "/ecs/crypto-api"
}