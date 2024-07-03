data "aws_ecr_image" "latest" {
  repository_name = "transaction-listener"
  most_recent     = true
}


resource "aws_ecs_task_definition" "Transaction-Listener-1" {
  family                   = "Transaction-Listener-1"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  task_role_arn            = aws_iam_role.Transaction_Listener_Task_Role.arn
  execution_role_arn       = aws_iam_role.Transaction_Listener_Task_Execution_Role.arn

  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }


  container_definitions = jsonencode([
    {
      name  = "Transaction-Listener-1"
      image = data.aws_ecr_image.latest.image_uri
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          "awslogs-create-group"  = "true",
          "awslogs-group"         = "/ecs/Transaction-Listener-1",
          "awslogs-region"        = "ap-southeast-1",
          "awslogs-stream-prefix" = "ecs",
        }
      }
      environment = [
        {
          name  = "NODE_ID"
          value = "tron-nile-alpha" // confirm
        },
        {
          name  = "NODE_ECO"
          value = "TRON" // confirm
        },
        {
          name  = "NODE_BLOCKCHAIN_ID"
          value = "tron-nile" // confirm
        },
        {
          name  = "CRYPTO_API_PROTOCOL"
          value = "http"
        },
        {
          name  = "CRYPTO_API_HOST"
          value = "crypto.lookcard.local"
        },
        {
          name  = "CRYPTO_API_PORT"
          value = "8080"
        },
        {
          name  = "DYNAMODB_BLOCK_RECORD_TABLE_NAME"
          value = "Crypto-Transaction-Listener-Block-Record" // confirm
        },
        {
          name  = "INCOMING_TRANSACTION_QUEUE_URL"
          value = var.aggregator_tron_sqs_url
        }

      ]
      secrets = [
        {
          name          = "TRONGRID_API_KEY"
          valueFrom     = "todo.trongrid_secret_arn"
        #   valueFrom     = "${var.trongrid_secret_arn}:API_KEY::"
        }
      ]
      portMappings = [
        {
          name          = "look-card-transaction-listener-8080-tcp",
          containerPort = 8080,
          hostPort      = 8080,
          protocol      = "tcp",
          appProtocol   = "http",
        },
      ]
      readonlyRootFilesystem : true
      command : ["node", "listener/tron.js"]
    }
  ])
}

resource "aws_cloudwatch_log_group" "transaction_listener" {
  name = "/ecs/Transaction-Listener-1"

}
