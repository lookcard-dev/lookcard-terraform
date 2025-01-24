data "aws_ecr_repository" "repository"{
  name = var.name
}

resource "aws_ecs_task_definition" "tron_nile_trongrid_task_definition" {
  count = var.runtime_environment == "develop" || var.runtime_environment == "testing" ? 1 : 0
  family                   = "crypto-listener_tron-nile-trongrid"
  network_mode             = "bridge"
  memory                   = 256
  task_role_arn            = aws_iam_role.task_role.arn
  execution_role_arn       = aws_iam_role.task_execution_role.arn
  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }
  container_definitions = jsonencode([
    {
      name  = "listener"
      image = "${data.aws_ecr_repository.repository.repository_url}:${var.image_tag}"
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          "awslogs-create-group"  = "true",
          "awslogs-group"         = "/ecs/crypto-listener/tron/nile/trongrid",
          "awslogs-region"        = "ap-southeast-1",
          "awslogs-stream-prefix" = "ecs",
        }
      }
      environment = concat(local.environment_variables, [
        {
          name = "NODE_ID",
          value = "tron-nile-trongrid"
        },
        {
          name = "NODE_ECO",
          value = "tron"
        },
        {
          name = "NODE_BLOCKCHAIN_ID",
          value = "tron-nile"
        },
        {
          name = "AWS_CLOUDWATCH_LOG_GROUP_NAME",
          value = "/ecs/crypto-listener/tron/nile/trongrid"
        }
      ])
      secrets = concat(local.environment_secrets, [
        {
          name      = "RPC_ENDPOINT"
          valueFrom = "${data.aws_secretsmanager_secret.trongrid.arn}:NILE_JSON_RPC_HTTP_ENDPOINT::"
        }
      ])
    }
  ])
}

resource "aws_ecs_task_definition" "tron_nile_getblock_task_definition" {
  count = var.runtime_environment == "develop" || var.runtime_environment == "testing" ? 1 : 0
  family                   = "crypto-listener_tron-nile-getblock"
  network_mode             = "bridge"
  memory                   = 256
  task_role_arn            = aws_iam_role.task_role.arn
  execution_role_arn       = aws_iam_role.task_execution_role.arn
  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }
  container_definitions = jsonencode([
    {
      name  = "listener"
      image = "${data.aws_ecr_repository.repository.repository_url}:${var.image_tag}"
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          "awslogs-create-group"  = "true",
          "awslogs-group"         = "/ecs/crypto-listener/tron/nile/getblock",
          "awslogs-region"        = "ap-southeast-1",
          "awslogs-stream-prefix" = "ecs",
        }
      }
      environment = concat(local.environment_variables, [
        {
          name = "NODE_ID",
          value = "tron-nile-getblock"
        },
        {
          name = "NODE_ECO",
          value = "tron"
        },
        {
          name = "NODE_BLOCKCHAIN_ID",
          value = "tron-nile"
        },
        {
          name = "AWS_CLOUDWATCH_LOG_GROUP_NAME",
          value = "/ecs/crypto-listener/tron/nile/getblock"
        }
      ])
      secrets = concat(local.environment_secrets, [
        {
          name      = "RPC_ENDPOINT"
          valueFrom = "${data.aws_secretsmanager_secret.getblock.arn}:TRON_NILE_JSON_RPC_HTTP_ENDPOINT::"
        }
      ])
    }
  ])
}


resource "aws_ecs_task_definition" "tron_trongrid_task_definition" {
  count = var.runtime_environment == "develop" || var.runtime_environment == "testing" ? 0 : 1
  family                   = "crypto-listener_tron-trongrid"
  network_mode             = "bridge"
  memory                   = 256
  task_role_arn            = aws_iam_role.task_role.arn
  execution_role_arn       = aws_iam_role.task_execution_role.arn
  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }
  container_definitions = jsonencode([
    {
      name  = "listener"
      image = "${data.aws_ecr_repository.repository.repository_url}:${var.image_tag}"
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          "awslogs-create-group"  = "true",
          "awslogs-group"         = "/ecs/crypto-listener/tron/mainnet/trongrid",
          "awslogs-region"        = "ap-southeast-1",
          "awslogs-stream-prefix" = "ecs",
        }
      }
      environment = concat(local.environment_variables, [
        {
          name = "NODE_ID",
          value = "tron-trongrid"
        },
        {
          name = "NODE_ECO",
          value = "tron"
        },
        {
          name = "NODE_BLOCKCHAIN_ID",
          value = "tron"
        },
        {
          name = "AWS_CLOUDWATCH_LOG_GROUP_NAME",
          value = "/ecs/crypto-listener/tron/mainnet/trongrid"
        }
      ])
      secrets = concat(local.environment_secrets, [
        {
          name      = "RPC_ENDPOINT"
          valueFrom = "${data.aws_secretsmanager_secret.trongrid.arn}:MAINNET_JSON_RPC_HTTP_ENDPOINT::"
        }
      ])
    }
  ])
}

resource "aws_ecs_task_definition" "tron_getblock_task_definition" {
  count = var.runtime_environment == "develop" || var.runtime_environment == "testing" ? 0 : 1
  family                   = "crypto-listener_tron-getblock"
  network_mode             = "bridge"
  memory                   = 256
  task_role_arn            = aws_iam_role.task_role.arn
  execution_role_arn       = aws_iam_role.task_execution_role.arn
  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }
  container_definitions = jsonencode([
    {
      name  = "listener"
      image = "${data.aws_ecr_repository.repository.repository_url}:${var.image_tag}"
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          "awslogs-create-group"  = "true",
          "awslogs-group"         = "/ecs/crypto-listener/tron/mainnet/getblock",
          "awslogs-region"        = "ap-southeast-1",
          "awslogs-stream-prefix" = "ecs",
        }
      }
      environment = concat(local.environment_variables, [
        {
          name = "NODE_ID",
          value = "tron-getblock"
        },
        {
          name = "NODE_ECO",
          value = "tron"
        },
        {
          name = "NODE_BLOCKCHAIN_ID",
          value = "tron"
        },
        {
          name = "AWS_CLOUDWATCH_LOG_GROUP_NAME",
          value = "/ecs/crypto-listener/tron/mainnet/getblock"
        }
      ])
      secrets = concat(local.environment_secrets, [
        {
          name      = "RPC_ENDPOINT"
          valueFrom = "${data.aws_secretsmanager_secret.getblock.arn}:TRON_MAINNET_JSON_RPC_HTTP_ENDPOINT::"
        }
      ])
    }
  ])
}

resource "aws_ecs_task_definition" "tron_drpc_task_definition" {
  count = var.runtime_environment == "develop" || var.runtime_environment == "testing" ? 0 : 1
  family                   = "crypto-listener_tron-drpc"
  network_mode             = "bridge"
  memory                   = 256
  task_role_arn            = aws_iam_role.task_role.arn
  execution_role_arn       = aws_iam_role.task_execution_role.arn
  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }
  container_definitions = jsonencode([
    {
      name  = "listener"
      image = "${data.aws_ecr_repository.repository.repository_url}:${var.image_tag}"
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          "awslogs-create-group"  = "true",
          "awslogs-group"         = "/ecs/crypto-listener/tron/mainnet/drpc",
          "awslogs-region"        = "ap-southeast-1",
          "awslogs-stream-prefix" = "ecs",
        }
      }
      environment = concat(local.environment_variables, [
        {
          name = "NODE_ID",
          value = "tron-drpc"
        },
        {
          name = "NODE_ECO",
          value = "tron"
        },
        {
          name = "NODE_BLOCKCHAIN_ID",
          value = "tron"
        },
        {
          name = "AWS_CLOUDWATCH_LOG_GROUP_NAME",
          value = "/ecs/crypto-listener/tron/mainnet/drpc"
        }
      ])
      secrets = concat(local.environment_secrets, [
        {
          name      = "RPC_ENDPOINT"
          valueFrom = "${data.aws_secretsmanager_secret.getblock.arn}:TRON_MAINNET_JSON_RPC_HTTP_ENDPOINT::"
        }
      ])
    }
  ])
}

resource "aws_ecs_task_definition" "tron_quicknode_task_definition" {
  count = var.runtime_environment == "develop" || var.runtime_environment == "testing" ? 0 : 1
  family                   = "crypto-listener_tron-quicknode"
  network_mode             = "bridge"
  memory                   = 256
  task_role_arn            = aws_iam_role.task_role.arn
  execution_role_arn       = aws_iam_role.task_execution_role.arn
  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }
  container_definitions = jsonencode([
    {
      name  = "listener"
      image = "${data.aws_ecr_repository.repository.repository_url}:${var.image_tag}"
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          "awslogs-create-group"  = "true",
          "awslogs-group"         = "/ecs/crypto-listener/tron/mainnet/quicknode",
          "awslogs-region"        = "ap-southeast-1",
          "awslogs-stream-prefix" = "ecs",
        }
      }
      environment = concat(local.environment_variables, [
        {
          name = "NODE_ID",
          value = "tron-quicknode"
        },
        {
          name = "NODE_ECO",
          value = "tron"
        },
        {
          name = "NODE_BLOCKCHAIN_ID",
          value = "tron"
        },
        {
          name = "AWS_CLOUDWATCH_LOG_GROUP_NAME",
          value = "/ecs/crypto-listener/tron/mainnet/quicknode"
        }
      ])
      secrets = concat(local.environment_secrets, [
        {
          name      = "RPC_ENDPOINT"
          valueFrom = "${data.aws_secretsmanager_secret.quicknode.arn}:TRON_MAINNET_JSON_RPC_HTTP_ENDPOINT::"
        }
      ])
    }
  ])
}

# BSC Testnet Task Definitions
resource "aws_ecs_task_definition" "bsc_testnet_infura_task_definition" {
  count = var.runtime_environment == "develop" || var.runtime_environment == "testing" ? 1 : 0
  family                   = "crypto-listener_bsc-testnet-infura"
  network_mode             = "bridge"
  memory                   = 256
  task_role_arn            = aws_iam_role.task_role.arn
  execution_role_arn       = aws_iam_role.task_execution_role.arn
  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }
  container_definitions = jsonencode([
    {
      name  = "listener"
      image = "${data.aws_ecr_repository.repository.repository_url}:${var.image_tag}"
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          "awslogs-create-group"  = "true",
          "awslogs-group"         = "/ecs/crypto-listener/bsc/testnet/infura",
          "awslogs-region"        = "ap-southeast-1",
          "awslogs-stream-prefix" = "ecs",
        }
      }
      environment = concat(local.environment_variables, [
        {
          name = "NODE_ID",
          value = "bsc-testnet-infura"
        },
        {
          name = "NODE_ECO",
          value = "ethereum"
        },
        {
          name = "NODE_BLOCKCHAIN_ID",
          value = "bsc-testnet"
        },
        {
          name = "AWS_CLOUDWATCH_LOG_GROUP_NAME",
          value = "/ecs/crypto-listener/bsc/testnet/infura"
        }
      ])
      secrets = concat(local.environment_secrets, [
        {
          name      = "RPC_ENDPOINT"
          valueFrom = "${data.aws_secretsmanager_secret.infura.arn}:BSC_TESTNET_JSON_RPC_HTTP_ENDPOINT::"
        }
      ])
    }
  ])
}

resource "aws_ecs_task_definition" "bsc_testnet_getblock_task_definition" {
  count = var.runtime_environment == "develop" || var.runtime_environment == "testing" ? 1 : 0
  family                   = "crypto-listener_bsc-testnet-getblock"
  network_mode             = "bridge"
  memory                   = 256
  task_role_arn            = aws_iam_role.task_role.arn
  execution_role_arn       = aws_iam_role.task_execution_role.arn
  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }
  container_definitions = jsonencode([
    {
      name  = "listener"
      image = "${data.aws_ecr_repository.repository.repository_url}:${var.image_tag}"
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          "awslogs-create-group"  = "true",
          "awslogs-group"         = "/ecs/crypto-listener/bsc/testnet/getblock",
          "awslogs-region"        = "ap-southeast-1",
          "awslogs-stream-prefix" = "ecs",
        }
      }
      environment = concat(local.environment_variables, [
        {
          name = "NODE_ID",
          value = "bsc-testnet-getblock"
        },
        {
          name = "NODE_ECO",
          value = "ethereum"
        },
        {
          name = "NODE_BLOCKCHAIN_ID",
          value = "bsc-testnet"
        },
        {
          name = "AWS_CLOUDWATCH_LOG_GROUP_NAME",
          value = "/ecs/crypto-listener/bsc/testnet/getblock"
        }
      ])
      secrets = concat(local.environment_secrets, [
        {
          name      = "RPC_ENDPOINT"
          valueFrom = "${data.aws_secretsmanager_secret.getblock.arn}:BSC_TESTNET_JSON_RPC_HTTP_ENDPOINT::"
        }
      ])
    }
  ])
}

# BSC Mainnet Task Definitions
resource "aws_ecs_task_definition" "bsc_infura_task_definition" {
  count = var.runtime_environment == "develop" || var.runtime_environment == "testing" ? 0 : 1
  family                   = "crypto-listener_bsc-infura"
  network_mode             = "bridge"
  memory                   = 256
  task_role_arn            = aws_iam_role.task_role.arn
  execution_role_arn       = aws_iam_role.task_execution_role.arn
  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }
  container_definitions = jsonencode([
    {
      name  = "listener"
      image = "${data.aws_ecr_repository.repository.repository_url}:${var.image_tag}"
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          "awslogs-create-group"  = "true",
          "awslogs-group"         = "/ecs/crypto-listener/bsc/mainnet/infura",
          "awslogs-region"        = "ap-southeast-1",
          "awslogs-stream-prefix" = "ecs",
        }
      }
      environment = concat(local.environment_variables, [
        {
          name = "NODE_ID",
          value = "bsc-infura"
        },
        {
          name = "NODE_ECO",
          value = "ethereum"
        },
        {
          name = "NODE_BLOCKCHAIN_ID",
          value = "bsc"
        },
        {
          name = "AWS_CLOUDWATCH_LOG_GROUP_NAME",
          value = "/ecs/crypto-listener/bsc/mainnet/infura"
        }
      ])
      secrets = concat(local.environment_secrets, [
        {
          name      = "RPC_ENDPOINT"
          valueFrom = "${data.aws_secretsmanager_secret.infura.arn}:BSC_MAINNET_JSON_RPC_HTTP_ENDPOINT::"
        }
      ])
    }
  ])
}

# BSC Mainnet GetBlock Task Definition
resource "aws_ecs_task_definition" "bsc_getblock_task_definition" {
  count = var.runtime_environment == "develop" || var.runtime_environment == "testing" ? 0 : 1
  family                   = "crypto-listener_bsc-getblock"
  network_mode             = "bridge"
  memory                   = 256
  task_role_arn            = aws_iam_role.task_role.arn
  execution_role_arn       = aws_iam_role.task_execution_role.arn
  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }
  container_definitions = jsonencode([
    {
      name  = "listener"
      image = "${data.aws_ecr_repository.repository.repository_url}:${var.image_tag}"
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          "awslogs-create-group"  = "true",
          "awslogs-group"         = "/ecs/crypto-listener/bsc/mainnet/getblock",
          "awslogs-region"        = "ap-southeast-1",
          "awslogs-stream-prefix" = "ecs",
        }
      }
      environment = concat(local.environment_variables, [
        {
          name = "NODE_ID",
          value = "bsc-getblock"
        },
        {
          name = "NODE_ECO",
          value = "ethereum"
        },
        {
          name = "NODE_BLOCKCHAIN_ID",
          value = "bsc"
        },
        {
          name = "AWS_CLOUDWATCH_LOG_GROUP_NAME",
          value = "/ecs/crypto-listener/bsc/mainnet/getblock"
        }
      ])
      secrets = concat(local.environment_secrets, [
        {
          name      = "RPC_ENDPOINT"
          valueFrom = "${data.aws_secretsmanager_secret.getblock.arn}:BSC_MAINNET_JSON_RPC_HTTP_ENDPOINT::"
        }
      ])
    }
  ])
}

# BSC Mainnet DRPC Task Definition
resource "aws_ecs_task_definition" "bsc_drpc_task_definition" {
  count = var.runtime_environment == "develop" || var.runtime_environment == "testing" ? 0 : 1
  family                   = "crypto-listener_bsc-drpc"
  network_mode             = "bridge"
  memory                   = 256
  task_role_arn            = aws_iam_role.task_role.arn
  execution_role_arn       = aws_iam_role.task_execution_role.arn
  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }
  container_definitions = jsonencode([
    {
      name  = "listener"
      image = "${data.aws_ecr_repository.repository.repository_url}:${var.image_tag}"
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          "awslogs-create-group"  = "true",
          "awslogs-group"         = "/ecs/crypto-listener/bsc/mainnet/drpc",
          "awslogs-region"        = "ap-southeast-1",
          "awslogs-stream-prefix" = "ecs",
        }
      }
      environment = concat(local.environment_variables, [
        {
          name = "NODE_ID",
          value = "bsc-drpc"
        },
        {
          name = "NODE_ECO",
          value = "ethereum"
        },
        {
          name = "NODE_BLOCKCHAIN_ID",
          value = "bsc"
        },
        {
          name = "AWS_CLOUDWATCH_LOG_GROUP_NAME",
          value = "/ecs/crypto-listener/bsc/mainnet/drpc"
        }
      ])
      secrets = concat(local.environment_secrets, [
        {
          name      = "RPC_ENDPOINT"
          valueFrom = "${data.aws_secretsmanager_secret.drpc.arn}:BSC_MAINNET_JSON_RPC_HTTP_ENDPOINT::"
        }
      ])
    }
  ])
}

# BSC Mainnet QuickNode Task Definition
resource "aws_ecs_task_definition" "bsc_quicknode_task_definition" {
  count = var.runtime_environment == "develop" || var.runtime_environment == "testing" ? 0 : 1
  family                   = "crypto-listener_bsc-quicknode"
  network_mode             = "bridge"
  memory                   = 256
  task_role_arn            = aws_iam_role.task_role.arn
  execution_role_arn       = aws_iam_role.task_execution_role.arn
  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }
  container_definitions = jsonencode([
    {
      name  = "listener"
      image = "${data.aws_ecr_repository.repository.repository_url}:${var.image_tag}"
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          "awslogs-create-group"  = "true",
          "awslogs-group"         = "/ecs/crypto-listener/bsc/mainnet/quicknode",
          "awslogs-region"        = "ap-southeast-1",
          "awslogs-stream-prefix" = "ecs",
        }
      }
      environment = concat(local.environment_variables, [
        {
          name = "NODE_ID",
          value = "bsc-quicknode"
        },
        {
          name = "NODE_ECO",
          value = "ethereum"
        },
        {
          name = "NODE_BLOCKCHAIN_ID",
          value = "bsc"
        },
        {
          name = "AWS_CLOUDWATCH_LOG_GROUP_NAME",
          value = "/ecs/crypto-listener/bsc/mainnet/quicknode"
        }
      ])
      secrets = concat(local.environment_secrets, [
        {
          name      = "RPC_ENDPOINT"
          valueFrom = "${data.aws_secretsmanager_secret.quicknode.arn}:BSC_MAINNET_JSON_RPC_HTTP_ENDPOINT::"
        }
      ])
    }
  ])
}

resource "aws_ecs_task_definition" "polygon_amoy_infura_task_definition" {
  count = var.runtime_environment == "develop" || var.runtime_environment == "testing" ? 1 : 0
  family                   = "crypto-listener_polygon-amoy-infura"
  network_mode             = "bridge"
  memory                   = 256
  task_role_arn            = aws_iam_role.task_role.arn
  execution_role_arn       = aws_iam_role.task_execution_role.arn
  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }
  container_definitions = jsonencode([
    {
      name  = "listener"
      image = "${data.aws_ecr_repository.repository.repository_url}:${var.image_tag}"
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          "awslogs-create-group"  = "true",
          "awslogs-group"         = "/ecs/crypto-listener/polygon/amoy/infura",
          "awslogs-region"        = "ap-southeast-1",
          "awslogs-stream-prefix" = "ecs",
        }
      }
      environment = concat(local.environment_variables, [
        {
          name = "NODE_ID",
          value = "polygon-amoy-infura"
        },
        {
          name = "NODE_ECO",
          value = "ethereum"
        },
        {
          name = "NODE_BLOCKCHAIN_ID",
          value = "polygon-amoy"
        },
        {
          name = "AWS_CLOUDWATCH_LOG_GROUP_NAME",
          value = "/ecs/crypto-listener/polygon/amoy/infura"
        }
      ])
      secrets = concat(local.environment_secrets, [
        {
          name      = "RPC_ENDPOINT"
          valueFrom = "${data.aws_secretsmanager_secret.infura.arn}:POLYGON_AMOY_JSON_RPC_HTTP_ENDPOINT::"
        }
      ])
    }
  ])
}

resource "aws_ecs_task_definition" "polygon_amoy_getblock_task_definition" {
  count = var.runtime_environment == "develop" || var.runtime_environment == "testing" ? 1 : 0
  family                   = "crypto-listener_polygon-amoy-getblock"
  network_mode             = "bridge"
  memory                   = 256
  task_role_arn            = aws_iam_role.task_role.arn
  execution_role_arn       = aws_iam_role.task_execution_role.arn
  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }
  container_definitions = jsonencode([
    {
      name  = "listener"
      image = "${data.aws_ecr_repository.repository.repository_url}:${var.image_tag}"
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          "awslogs-create-group"  = "true",
          "awslogs-group"         = "/ecs/crypto-listener/polygon/amoy/getblock",
          "awslogs-region"        = "ap-southeast-1",
          "awslogs-stream-prefix" = "ecs",
        }
      }
      environment = concat(local.environment_variables, [
        {
          name = "NODE_ID",
          value = "polygon-amoy-getblock"
        },
        {
          name = "NODE_ECO",
          value = "ethereum"
        },
        {
          name = "NODE_BLOCKCHAIN_ID",
          value = "polygon-amoy"
        },
        {
          name = "AWS_CLOUDWATCH_LOG_GROUP_NAME",
          value = "/ecs/crypto-listener/polygon/amoy/getblock"
        }
      ])
      secrets = concat(local.environment_secrets, [
        {
          name      = "RPC_ENDPOINT"
          valueFrom = "${data.aws_secretsmanager_secret.getblock.arn}:POLYGON_AMOY_JSON_RPC_HTTP_ENDPOINT::"
        }
      ])
    }
  ])
}

# Polygon Mainnet Task Definitions
resource "aws_ecs_task_definition" "polygon_infura_task_definition" {
  count = var.runtime_environment == "develop" || var.runtime_environment == "testing" ? 0 : 1
  family                   = "crypto-listener_polygon-infura"
  network_mode             = "bridge"
  memory                   = 256
  task_role_arn            = aws_iam_role.task_role.arn
  execution_role_arn       = aws_iam_role.task_execution_role.arn
  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }
  container_definitions = jsonencode([
    {
      name  = "listener"
      image = "${data.aws_ecr_repository.repository.repository_url}:${var.image_tag}"
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          "awslogs-create-group"  = "true",
          "awslogs-group"         = "/ecs/crypto-listener/polygon/mainnet/infura",
          "awslogs-region"        = "ap-southeast-1",
          "awslogs-stream-prefix" = "ecs",
        }
      }
      environment = concat(local.environment_variables, [
        {
          name = "NODE_ID",
          value = "polygon-infura"
        },
        {
          name = "NODE_ECO",
          value = "ethereum"
        },
        {
          name = "NODE_BLOCKCHAIN_ID",
          value = "polygon"
        },
        {
          name = "AWS_CLOUDWATCH_LOG_GROUP_NAME",
          value = "/ecs/crypto-listener/polygon/mainnet/infura"
        }
      ])
      secrets = concat(local.environment_secrets, [
        {
          name      = "RPC_ENDPOINT"
          valueFrom = "${data.aws_secretsmanager_secret.infura.arn}:POLYGON_MAINNET_JSON_RPC_HTTP_ENDPOINT::"
        }
      ])
    }
  ])
}

resource "aws_ecs_task_definition" "polygon_getblock_task_definition" {
  count = var.runtime_environment == "develop" || var.runtime_environment == "testing" ? 0 : 1
  family                   = "crypto-listener_polygon-getblock"
  network_mode             = "bridge"
  memory                   = 256
  task_role_arn            = aws_iam_role.task_role.arn
  execution_role_arn       = aws_iam_role.task_execution_role.arn
  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }
  container_definitions = jsonencode([
    {
      name  = "listener"
      image = "${data.aws_ecr_repository.repository.repository_url}:${var.image_tag}"
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          "awslogs-create-group"  = "true",
          "awslogs-group"         = "/ecs/crypto-listener/polygon/mainnet/getblock",
          "awslogs-region"        = "ap-southeast-1",
          "awslogs-stream-prefix" = "ecs",
        }
      }
      environment = concat(local.environment_variables, [
        {
          name = "NODE_ID",
          value = "polygon-getblock"
        },
        {
          name = "NODE_ECO",
          value = "ethereum"
        },
        {
          name = "NODE_BLOCKCHAIN_ID",
          value = "polygon"
        },
        {
          name = "AWS_CLOUDWATCH_LOG_GROUP_NAME",
          value = "/ecs/crypto-listener/polygon/mainnet/getblock"
        }
      ])
      secrets = concat(local.environment_secrets, [
        {
          name      = "RPC_ENDPOINT"
          valueFrom = "${data.aws_secretsmanager_secret.getblock.arn}:POLYGON_MAINNET_JSON_RPC_HTTP_ENDPOINT::"
        }
      ])
    }
  ])
}

# Polygon Mainnet DRPC Task Definition
resource "aws_ecs_task_definition" "polygon_drpc_task_definition" {
  count = var.runtime_environment == "develop" || var.runtime_environment == "testing" ? 0 : 1
  family                   = "crypto-listener_polygon-drpc"
  network_mode             = "bridge"
  memory                   = 256
  task_role_arn            = aws_iam_role.task_role.arn
  execution_role_arn       = aws_iam_role.task_execution_role.arn
  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }
  container_definitions = jsonencode([
    {
      name  = "listener"
      image = "${data.aws_ecr_repository.repository.repository_url}:${var.image_tag}"
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          "awslogs-create-group"  = "true",
          "awslogs-group"         = "/ecs/crypto-listener/polygon/mainnet/drpc",
          "awslogs-region"        = "ap-southeast-1",
          "awslogs-stream-prefix" = "ecs",
        }
      }
      environment = concat(local.environment_variables, [
        {
          name = "NODE_ID",
          value = "polygon-drpc"
        },
        {
          name = "NODE_ECO",
          value = "ethereum"
        },
        {
          name = "NODE_BLOCKCHAIN_ID",
          value = "polygon"
        },
        {
          name = "AWS_CLOUDWATCH_LOG_GROUP_NAME",
          value = "/ecs/crypto-listener/polygon/mainnet/drpc"
        }
      ])
      secrets = concat(local.environment_secrets, [
        {
          name      = "RPC_ENDPOINT"
          valueFrom = "${data.aws_secretsmanager_secret.drpc.arn}:POLYGON_MAINNET_JSON_RPC_HTTP_ENDPOINT::"
        }
      ])
    }
  ])
}

# Polygon Mainnet QuickNode Task Definition
resource "aws_ecs_task_definition" "polygon_quicknode_task_definition" {
  count = var.runtime_environment == "develop" || var.runtime_environment == "testing" ? 0 : 1
  family                   = "crypto-listener_polygon-quicknode"
  network_mode             = "bridge"
  memory                   = 256
  task_role_arn            = aws_iam_role.task_role.arn
  execution_role_arn       = aws_iam_role.task_execution_role.arn
  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }
  container_definitions = jsonencode([
    {
      name  = "listener"
      image = "${data.aws_ecr_repository.repository.repository_url}:${var.image_tag}"
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          "awslogs-create-group"  = "true",
          "awslogs-group"         = "/ecs/crypto-listener/polygon/mainnet/quicknode",
          "awslogs-region"        = "ap-southeast-1",
          "awslogs-stream-prefix" = "ecs",
        }
      }
      environment = concat(local.environment_variables, [
        {
          name = "NODE_ID",
          value = "polygon-quicknode"
        },
        {
          name = "NODE_ECO",
          value = "ethereum"
        },
        {
          name = "NODE_BLOCKCHAIN_ID",
          value = "polygon"
        },
        {
          name = "AWS_CLOUDWATCH_LOG_GROUP_NAME",
          value = "/ecs/crypto-listener/polygon/mainnet/quicknode"
        }
      ])
      secrets = concat(local.environment_secrets, [
        {
          name      = "RPC_ENDPOINT"
          valueFrom = "${data.aws_secretsmanager_secret.quicknode.arn}:POLYGON_MAINNET_JSON_RPC_HTTP_ENDPOINT::"
        }
      ])
    }
  ])
}

resource "aws_ecs_task_definition" "avalanche_fuji_infura_task_definition" {
  count = var.runtime_environment == "develop" || var.runtime_environment == "testing" ? 1 : 0
  family                   = "crypto-listener_avalanche-fuji-infura"
  network_mode             = "bridge"
  memory                   = 256
  task_role_arn            = aws_iam_role.task_role.arn
  execution_role_arn       = aws_iam_role.task_execution_role.arn
  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }
  container_definitions = jsonencode([
    {
      name  = "listener"
      image = "${data.aws_ecr_repository.repository.repository_url}:${var.image_tag}"
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          "awslogs-create-group"  = "true",
          "awslogs-group"         = "/ecs/crypto-listener/avalanche/fuji/infura",
          "awslogs-region"        = "ap-southeast-1",
          "awslogs-stream-prefix" = "ecs",
        }
      }
      environment = concat(local.environment_variables, [
        {
          name = "NODE_ID",
          value = "avalanche-fuji-infura"
        },
        {
          name = "NODE_ECO",
          value = "ethereum"
        },
        {
          name = "NODE_BLOCKCHAIN_ID",
          value = "avalanche-fuji"
        },
        {
          name = "AWS_CLOUDWATCH_LOG_GROUP_NAME",
          value = "/ecs/crypto-listener/avalanche/fuji/infura"
        }
      ])
      secrets = concat(local.environment_secrets, [
        {
          name      = "RPC_ENDPOINT"
          valueFrom = "${data.aws_secretsmanager_secret.infura.arn}:AVALANCHE_FUJI_JSON_RPC_HTTP_ENDPOINT::"
        }
      ])
    }
  ])
}

resource "aws_ecs_task_definition" "avalanche_fuji_getblock_task_definition" {
  count = var.runtime_environment == "develop" || var.runtime_environment == "testing" ? 1 : 0
  family                   = "crypto-listener_avalanche-fuji-getblock"
  network_mode             = "bridge"
  memory                   = 256
  task_role_arn            = aws_iam_role.task_role.arn
  execution_role_arn       = aws_iam_role.task_execution_role.arn
  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }
  container_definitions = jsonencode([
    {
      name  = "listener"
      image = "${data.aws_ecr_repository.repository.repository_url}:${var.image_tag}"
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          "awslogs-create-group"  = "true",
          "awslogs-group"         = "/ecs/crypto-listener/avalanche/fuji/getblock",
          "awslogs-region"        = "ap-southeast-1",
          "awslogs-stream-prefix" = "ecs",
        }
      }
      environment = concat(local.environment_variables, [
        {
          name = "NODE_ID",
          value = "avalanche-fuji-getblock"
        },
        {
          name = "NODE_ECO",
          value = "ethereum"
        },
        {
          name = "NODE_BLOCKCHAIN_ID",
          value = "avalanche-fuji"
        },
        {
          name = "AWS_CLOUDWATCH_LOG_GROUP_NAME",
          value = "/ecs/crypto-listener/avalanche/fuji/getblock"
        }
      ])
      secrets = concat(local.environment_secrets, [
        {
          name      = "RPC_ENDPOINT"
          valueFrom = "${data.aws_secretsmanager_secret.getblock.arn}:AVALANCHE_FUJI_JSON_RPC_HTTP_ENDPOINT::"
        }
      ])
    }
  ])
}

# Avalanche Mainnet Task Definitions
resource "aws_ecs_task_definition" "avalanche_infura_task_definition" {
  count = var.runtime_environment == "develop" || var.runtime_environment == "testing" ? 0 : 1
  family                   = "crypto-listener_avalanche-infura"
  network_mode             = "bridge"
  memory                   = 256
  task_role_arn            = aws_iam_role.task_role.arn
  execution_role_arn       = aws_iam_role.task_execution_role.arn
  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }
  container_definitions = jsonencode([
    {
      name  = "listener"
      image = "${data.aws_ecr_repository.repository.repository_url}:${var.image_tag}"
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          "awslogs-create-group"  = "true",
          "awslogs-group"         = "/ecs/crypto-listener/avalanche/mainnet/infura",
          "awslogs-region"        = "ap-southeast-1",
          "awslogs-stream-prefix" = "ecs",
        }
      }
      environment = concat(local.environment_variables, [
        {
          name = "NODE_ID",
          value = "avalanche-infura"
        },
        {
          name = "NODE_ECO",
          value = "ethereum"
        },
        {
          name = "NODE_BLOCKCHAIN_ID",
          value = "avalanche"
        },
        {
          name = "AWS_CLOUDWATCH_LOG_GROUP_NAME",
          value = "/ecs/crypto-listener/avalanche/mainnet/infura"
        }
      ])
      secrets = concat(local.environment_secrets, [
        {
          name      = "RPC_ENDPOINT"
          valueFrom = "${data.aws_secretsmanager_secret.infura.arn}:AVALANCHE_MAINNET_JSON_RPC_HTTP_ENDPOINT::"
        }
      ])
    }
  ])
}

# Avalanche Mainnet GetBlock Task Definition
resource "aws_ecs_task_definition" "avalanche_getblock_task_definition" {
  count = var.runtime_environment == "develop" || var.runtime_environment == "testing" ? 0 : 1
  family                   = "crypto-listener_avalanche-getblock"
  network_mode             = "bridge"
  memory                   = 256
  task_role_arn            = aws_iam_role.task_role.arn
  execution_role_arn       = aws_iam_role.task_execution_role.arn
  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }
  container_definitions = jsonencode([
    {
      name  = "listener"
      image = "${data.aws_ecr_repository.repository.repository_url}:${var.image_tag}"
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          "awslogs-create-group"  = "true",
          "awslogs-group"         = "/ecs/crypto-listener/avalanche/mainnet/getblock",
          "awslogs-region"        = "ap-southeast-1",
          "awslogs-stream-prefix" = "ecs",
        }
      }
      environment = concat(local.environment_variables, [
        {
          name = "NODE_ID",
          value = "avalanche-getblock"
        },
        {
          name = "NODE_ECO",
          value = "ethereum"
        },
        {
          name = "NODE_BLOCKCHAIN_ID",
          value = "avalanche"
        },
        {
          name = "AWS_CLOUDWATCH_LOG_GROUP_NAME",
          value = "/ecs/crypto-listener/avalanche/mainnet/getblock"
        }
      ])
      secrets = concat(local.environment_secrets, [
        {
          name      = "RPC_ENDPOINT"
          valueFrom = "${data.aws_secretsmanager_secret.getblock.arn}:AVALANCHE_MAINNET_JSON_RPC_HTTP_ENDPOINT::"
        }
      ])
    }
  ])
}

# Avalanche Mainnet DRPC Task Definition
resource "aws_ecs_task_definition" "avalanche_drpc_task_definition" {
  count = var.runtime_environment == "develop" || var.runtime_environment == "testing" ? 0 : 1
  family                   = "crypto-listener_avalanche-drpc"
  network_mode             = "bridge"
  memory                   = 256
  task_role_arn            = aws_iam_role.task_role.arn
  execution_role_arn       = aws_iam_role.task_execution_role.arn
  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }
  container_definitions = jsonencode([
    {
      name  = "listener"
      image = "${data.aws_ecr_repository.repository.repository_url}:${var.image_tag}"
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          "awslogs-create-group"  = "true",
          "awslogs-group"         = "/ecs/crypto-listener/avalanche/mainnet/drpc",
          "awslogs-region"        = "ap-southeast-1",
          "awslogs-stream-prefix" = "ecs",
        }
      }
      environment = concat(local.environment_variables, [
        {
          name = "NODE_ID",
          value = "avalanche-drpc"
        },
        {
          name = "NODE_ECO",
          value = "ethereum"
        },
        {
          name = "NODE_BLOCKCHAIN_ID",
          value = "avalanche"
        },
        {
          name = "AWS_CLOUDWATCH_LOG_GROUP_NAME",
          value = "/ecs/crypto-listener/avalanche/mainnet/drpc"
        }
      ])
      secrets = concat(local.environment_secrets, [
        {
          name      = "RPC_ENDPOINT"
          valueFrom = "${data.aws_secretsmanager_secret.drpc.arn}:AVALANCHE_MAINNET_JSON_RPC_HTTP_ENDPOINT::"
        }
      ])
    }
  ])
}

# Avalanche Mainnet QuickNode Task Definition
resource "aws_ecs_task_definition" "avalanche_quicknode_task_definition" {
  count = var.runtime_environment == "develop" || var.runtime_environment == "testing" ? 0 : 1
  family                   = "crypto-listener_avalanche-quicknode"
  network_mode             = "bridge"
  memory                   = 256
  task_role_arn            = aws_iam_role.task_role.arn
  execution_role_arn       = aws_iam_role.task_execution_role.arn
  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }
  container_definitions = jsonencode([
    {
      name  = "listener"
      image = "${data.aws_ecr_repository.repository.repository_url}:${var.image_tag}"
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          "awslogs-create-group"  = "true",
          "awslogs-group"         = "/ecs/crypto-listener/avalanche/mainnet/quicknode",
          "awslogs-region"        = "ap-southeast-1",
          "awslogs-stream-prefix" = "ecs",
        }
      }
      environment = concat(local.environment_variables, [
        {
          name = "NODE_ID",
          value = "avalanche-quicknode"
        },
        {
          name = "NODE_ECO",
          value = "ethereum"
        },
        {
          name = "NODE_BLOCKCHAIN_ID",
          value = "avalanche"
        },
        {
          name = "AWS_CLOUDWATCH_LOG_GROUP_NAME",
          value = "/ecs/crypto-listener/avalanche/mainnet/quicknode"
        }
      ])
      secrets = concat(local.environment_secrets, [
        {
          name      = "RPC_ENDPOINT"
          valueFrom = "${data.aws_secretsmanager_secret.quicknode.arn}:AVALANCHE_MAINNET_JSON_RPC_HTTP_ENDPOINT::"
        }
      ])
    }
  ])
}

# Arbitrum Sepolia (Testnet) Task Definitions
resource "aws_ecs_task_definition" "arbitrum_sepolia_infura_task_definition" {
  count = var.runtime_environment == "develop" || var.runtime_environment == "testing" ? 1 : 0
  family                   = "crypto-listener_arbitrum-sepolia-infura"
  network_mode             = "bridge"
  memory                   = 256
  task_role_arn            = aws_iam_role.task_role.arn
  execution_role_arn       = aws_iam_role.task_execution_role.arn
  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }
  container_definitions = jsonencode([
    {
      name  = "listener"
      image = "${data.aws_ecr_repository.repository.repository_url}:${var.image_tag}"
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          "awslogs-create-group"  = "true",
          "awslogs-group"         = "/ecs/crypto-listener/arbitrum/sepolia/infura",
          "awslogs-region"        = "ap-southeast-1",
          "awslogs-stream-prefix" = "ecs",
        }
      }
      environment = concat(local.environment_variables, [
        {
          name = "NODE_ID",
          value = "arbitrum-sepolia-infura"
        },
        {
          name = "NODE_ECO",
          value = "ethereum"
        },
        {
          name = "NODE_BLOCKCHAIN_ID",
          value = "arbitrum-sepolia"
        },
        {
          name = "AWS_CLOUDWATCH_LOG_GROUP_NAME",
          value = "/ecs/crypto-listener/arbitrum/sepolia/infura"
        }
      ])
      secrets = concat(local.environment_secrets, [
        {
          name      = "RPC_ENDPOINT"
          valueFrom = "${data.aws_secretsmanager_secret.infura.arn}:ARBITRUM_SEPOLIA_JSON_RPC_HTTP_ENDPOINT::"
        }
      ])
    }
  ])
}

# Arbitrum Mainnet Task Definitions
resource "aws_ecs_task_definition" "arbitrum_infura_task_definition" {
  count = var.runtime_environment == "develop" || var.runtime_environment == "testing" ? 0 : 1
  family                   = "crypto-listener_arbitrum-infura"
  network_mode             = "bridge"
  memory                   = 256
  task_role_arn            = aws_iam_role.task_role.arn
  execution_role_arn       = aws_iam_role.task_execution_role.arn
  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }
  container_definitions = jsonencode([
    {
      name  = "listener"
      image = "${data.aws_ecr_repository.repository.repository_url}:${var.image_tag}"
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          "awslogs-create-group"  = "true",
          "awslogs-group"         = "/ecs/crypto-listener/arbitrum/mainnet/infura",
          "awslogs-region"        = "ap-southeast-1",
          "awslogs-stream-prefix" = "ecs",
        }
      }
      environment = concat(local.environment_variables, [
        {
          name = "NODE_ID",
          value = "arbitrum-infura"
        },
        {
          name = "NODE_ECO",
          value = "ethereum"
        },
        {
          name = "NODE_BLOCKCHAIN_ID",
          value = "arbitrum"
        },
        {
          name = "AWS_CLOUDWATCH_LOG_GROUP_NAME",
          value = "/ecs/crypto-listener/arbitrum/mainnet/infura"
        }
      ])
      secrets = concat(local.environment_secrets, [
        {
          name      = "RPC_ENDPOINT"
          valueFrom = "${data.aws_secretsmanager_secret.infura.arn}:ARBITRUM_MAINNET_JSON_RPC_HTTP_ENDPOINT::"
        }
      ])
    }
  ])
}

# Arbitrum Mainnet GetBlock Task Definition
resource "aws_ecs_task_definition" "arbitrum_getblock_task_definition" {
  count = var.runtime_environment == "develop" || var.runtime_environment == "testing" ? 0 : 1
  family                   = "crypto-listener_arbitrum-getblock"
  network_mode             = "bridge"
  memory                   = 256
  task_role_arn            = aws_iam_role.task_role.arn
  execution_role_arn       = aws_iam_role.task_execution_role.arn
  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }
  container_definitions = jsonencode([
    {
      name  = "listener"
      image = "${data.aws_ecr_repository.repository.repository_url}:${var.image_tag}"
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          "awslogs-create-group"  = "true",
          "awslogs-group"         = "/ecs/crypto-listener/arbitrum/mainnet/getblock",
          "awslogs-region"        = "ap-southeast-1",
          "awslogs-stream-prefix" = "ecs",
        }
      }
      environment = concat(local.environment_variables, [
        {
          name = "NODE_ID",
          value = "arbitrum-getblock"
        },
        {
          name = "NODE_ECO",
          value = "ethereum"
        },
        {
          name = "NODE_BLOCKCHAIN_ID",
          value = "arbitrum"
        },
        {
          name = "AWS_CLOUDWATCH_LOG_GROUP_NAME",
          value = "/ecs/crypto-listener/arbitrum/mainnet/getblock"
        }
      ])
      secrets = concat(local.environment_secrets, [
        {
          name      = "RPC_ENDPOINT"
          valueFrom = "${data.aws_secretsmanager_secret.getblock.arn}:ARBITRUM_MAINNET_JSON_RPC_HTTP_ENDPOINT::"
        }
      ])
    }
  ])
}

# Arbitrum Mainnet DRPC Task Definition
resource "aws_ecs_task_definition" "arbitrum_drpc_task_definition" {
  count = var.runtime_environment == "develop" || var.runtime_environment == "testing" ? 0 : 1
  family                   = "crypto-listener_arbitrum-drpc"
  network_mode             = "bridge"
  memory                   = 256
  task_role_arn            = aws_iam_role.task_role.arn
  execution_role_arn       = aws_iam_role.task_execution_role.arn
  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }
  container_definitions = jsonencode([
    {
      name  = "listener"
      image = "${data.aws_ecr_repository.repository.repository_url}:${var.image_tag}"
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          "awslogs-create-group"  = "true",
          "awslogs-group"         = "/ecs/crypto-listener/arbitrum/mainnet/drpc",
          "awslogs-region"        = "ap-southeast-1",
          "awslogs-stream-prefix" = "ecs",
        }
      }
      environment = concat(local.environment_variables, [
        {
          name = "NODE_ID",
          value = "arbitrum-drpc"
        },
        {
          name = "NODE_ECO",
          value = "ethereum"
        },
        {
          name = "NODE_BLOCKCHAIN_ID",
          value = "arbitrum"
        },
        {
          name = "AWS_CLOUDWATCH_LOG_GROUP_NAME",
          value = "/ecs/crypto-listener/arbitrum/mainnet/drpc"
        }
      ])
      secrets = concat(local.environment_secrets, [
        {
          name      = "RPC_ENDPOINT"
          valueFrom = "${data.aws_secretsmanager_secret.drpc.arn}:ARBITRUM_MAINNET_JSON_RPC_HTTP_ENDPOINT::"
        }
      ])
    }
  ])
}

# Arbitrum Mainnet QuickNode Task Definition
resource "aws_ecs_task_definition" "arbitrum_quicknode_task_definition" {
  count = var.runtime_environment == "develop" || var.runtime_environment == "testing" ? 0 : 1
  family                   = "crypto-listener_arbitrum-quicknode"
  network_mode             = "bridge"
  memory                   = 256
  task_role_arn            = aws_iam_role.task_role.arn
  execution_role_arn       = aws_iam_role.task_execution_role.arn
  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }
  container_definitions = jsonencode([
    {
      name  = "listener"
      image = "${data.aws_ecr_repository.repository.repository_url}:${var.image_tag}"
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          "awslogs-create-group"  = "true",
          "awslogs-group"         = "/ecs/crypto-listener/arbitrum/mainnet/quicknode",
          "awslogs-region"        = "ap-southeast-1",
          "awslogs-stream-prefix" = "ecs",
        }
      }
      environment = concat(local.environment_variables, [
        {
          name = "NODE_ID",
          value = "arbitrum-quicknode"
        },
        {
          name = "NODE_ECO",
          value = "ethereum"
        },
        {
          name = "NODE_BLOCKCHAIN_ID",
          value = "arbitrum"
        },
        {
          name = "AWS_CLOUDWATCH_LOG_GROUP_NAME",
          value = "/ecs/crypto-listener/arbitrum/mainnet/quicknode"
        }
      ])
      secrets = concat(local.environment_secrets, [
        {
          name      = "RPC_ENDPOINT"
          valueFrom = "${data.aws_secretsmanager_secret.quicknode.arn}:ARBITRUM_MAINNET_JSON_RPC_HTTP_ENDPOINT::"
        }
      ])
    }
  ])
}

# Optimism Sepolia (Testnet) Task Definitions
resource "aws_ecs_task_definition" "optimism_sepolia_infura_task_definition" {
  count = var.runtime_environment == "develop" || var.runtime_environment == "testing" ? 1 : 0
  family                   = "crypto-listener_optimism-sepolia-infura"
  network_mode             = "bridge"
  memory                   = 256
  task_role_arn            = aws_iam_role.task_role.arn
  execution_role_arn       = aws_iam_role.task_execution_role.arn
  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }
  container_definitions = jsonencode([
    {
      name  = "listener"
      image = "${data.aws_ecr_repository.repository.repository_url}:${var.image_tag}"
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          "awslogs-create-group"  = "true",
          "awslogs-group"         = "/ecs/crypto-listener/optimism/sepolia/infura",
          "awslogs-region"        = "ap-southeast-1",
          "awslogs-stream-prefix" = "ecs",
        }
      }
      environment = concat(local.environment_variables, [
        {
          name = "NODE_ID",
          value = "optimism-sepolia-infura"
        },
        {
          name = "NODE_ECO",
          value = "ethereum"
        },
        {
          name = "NODE_BLOCKCHAIN_ID",
          value = "optimism-sepolia"
        },
        {
          name = "AWS_CLOUDWATCH_LOG_GROUP_NAME",
          value = "/ecs/crypto-listener/optimism/sepolia/infura"
        }
      ])
      secrets = concat(local.environment_secrets, [
        {
          name      = "RPC_ENDPOINT"
          valueFrom = "${data.aws_secretsmanager_secret.infura.arn}:OPTIMISM_SEPOLIA_JSON_RPC_HTTP_ENDPOINT::"
        }
      ])
    }
  ])
}

# Optimism Mainnet Task Definitions
resource "aws_ecs_task_definition" "optimism_infura_task_definition" {
  count = var.runtime_environment == "develop" || var.runtime_environment == "testing" ? 0 : 1
  family                   = "crypto-listener_optimism-infura"
  network_mode             = "bridge"
  memory                   = 256
  task_role_arn            = aws_iam_role.task_role.arn
  execution_role_arn       = aws_iam_role.task_execution_role.arn
  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }
  container_definitions = jsonencode([
    {
      name  = "listener"
      image = "${data.aws_ecr_repository.repository.repository_url}:${var.image_tag}"
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          "awslogs-create-group"  = "true",
          "awslogs-group"         = "/ecs/crypto-listener/optimism/mainnet/infura",
          "awslogs-region"        = "ap-southeast-1",
          "awslogs-stream-prefix" = "ecs",
        }
      }
      environment = concat(local.environment_variables, [
        {
          name = "NODE_ID",
          value = "optimism-infura"
        },
        {
          name = "NODE_ECO",
          value = "ethereum"
        },
        {
          name = "NODE_BLOCKCHAIN_ID",
          value = "optimism"
        },
        {
          name = "AWS_CLOUDWATCH_LOG_GROUP_NAME",
          value = "/ecs/crypto-listener/optimism/mainnet/infura"
        }
      ])
      secrets = concat(local.environment_secrets, [
        {
          name      = "RPC_ENDPOINT"
          valueFrom = "${data.aws_secretsmanager_secret.infura.arn}:OPTIMISM_MAINNET_JSON_RPC_HTTP_ENDPOINT::"
        }
      ])
    }
  ])
}

# Optimism Mainnet GetBlock Task Definition
resource "aws_ecs_task_definition" "optimism_getblock_task_definition" {
  count = var.runtime_environment == "develop" || var.runtime_environment == "testing" ? 0 : 1
  family                   = "crypto-listener_optimism-getblock"
  network_mode             = "bridge"
  memory                   = 256
  task_role_arn            = aws_iam_role.task_role.arn
  execution_role_arn       = aws_iam_role.task_execution_role.arn
  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }
  container_definitions = jsonencode([
    {
      name  = "listener"
      image = "${data.aws_ecr_repository.repository.repository_url}:${var.image_tag}"
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          "awslogs-create-group"  = "true",
          "awslogs-group"         = "/ecs/crypto-listener/optimism/mainnet/getblock",
          "awslogs-region"        = "ap-southeast-1",
          "awslogs-stream-prefix" = "ecs",
        }
      }
      environment = concat(local.environment_variables, [
        {
          name = "NODE_ID",
          value = "optimism-getblock"
        },
        {
          name = "NODE_ECO",
          value = "ethereum"
        },
        {
          name = "NODE_BLOCKCHAIN_ID",
          value = "optimism"
        },
        {
          name = "AWS_CLOUDWATCH_LOG_GROUP_NAME",
          value = "/ecs/crypto-listener/optimism/mainnet/getblock"
        }
      ])
      secrets = concat(local.environment_secrets, [
        {
          name      = "RPC_ENDPOINT"
          valueFrom = "${data.aws_secretsmanager_secret.getblock.arn}:OPTIMISM_MAINNET_JSON_RPC_HTTP_ENDPOINT::"
        }
      ])
    }
  ])
}

# Optimism Mainnet DRPC Task Definition
resource "aws_ecs_task_definition" "optimism_drpc_task_definition" {
  count = var.runtime_environment == "develop" || var.runtime_environment == "testing" ? 0 : 1
  family                   = "crypto-listener_optimism-drpc"
  network_mode             = "bridge"
  memory                   = 256
  task_role_arn            = aws_iam_role.task_role.arn
  execution_role_arn       = aws_iam_role.task_execution_role.arn
  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }
  container_definitions = jsonencode([
    {
      name  = "listener"
      image = "${data.aws_ecr_repository.repository.repository_url}:${var.image_tag}"
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          "awslogs-create-group"  = "true",
          "awslogs-group"         = "/ecs/crypto-listener/optimism/mainnet/drpc",
          "awslogs-region"        = "ap-southeast-1",
          "awslogs-stream-prefix" = "ecs",
        }
      }
      environment = concat(local.environment_variables, [
        {
          name = "NODE_ID",
          value = "optimism-drpc"
        },
        {
          name = "NODE_ECO",
          value = "ethereum"
        },
        {
          name = "NODE_BLOCKCHAIN_ID",
          value = "optimism"
        },
        {
          name = "AWS_CLOUDWATCH_LOG_GROUP_NAME",
          value = "/ecs/crypto-listener/optimism/mainnet/drpc"
        }
      ])
      secrets = concat(local.environment_secrets, [
        {
          name      = "RPC_ENDPOINT"
          valueFrom = "${data.aws_secretsmanager_secret.drpc.arn}:OPTIMISM_MAINNET_JSON_RPC_HTTP_ENDPOINT::"
        }
      ])
    }
  ])
}

# Optimism Mainnet QuickNode Task Definition
resource "aws_ecs_task_definition" "optimism_quicknode_task_definition" {
  count = var.runtime_environment == "develop" || var.runtime_environment == "testing" ? 0 : 1
  family                   = "crypto-listener_optimism-quicknode"
  network_mode             = "bridge"
  memory                   = 256
  task_role_arn            = aws_iam_role.task_role.arn
  execution_role_arn       = aws_iam_role.task_execution_role.arn
  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }
  container_definitions = jsonencode([
    {
      name  = "listener"
      image = "${data.aws_ecr_repository.repository.repository_url}:${var.image_tag}"
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          "awslogs-create-group"  = "true",
          "awslogs-group"         = "/ecs/crypto-listener/optimism/mainnet/quicknode",
          "awslogs-region"        = "ap-southeast-1",
          "awslogs-stream-prefix" = "ecs",
        }
      }
      environment = concat(local.environment_variables, [
        {
          name = "NODE_ID",
          value = "optimism-quicknode"
        },
        {
          name = "NODE_ECO",
          value = "ethereum"
        },
        {
          name = "NODE_BLOCKCHAIN_ID",
          value = "optimism"
        },
        {
          name = "AWS_CLOUDWATCH_LOG_GROUP_NAME",
          value = "/ecs/crypto-listener/optimism/mainnet/quicknode"
        }
      ])
      secrets = concat(local.environment_secrets, [
        {
          name      = "RPC_ENDPOINT"
          valueFrom = "${data.aws_secretsmanager_secret.quicknode.arn}:OPTIMISM_MAINNET_JSON_RPC_HTTP_ENDPOINT::"
        }
      ])
    }
  ])
}

# Base Sepolia (Testnet) Task Definitions
resource "aws_ecs_task_definition" "base_sepolia_infura_task_definition" {
  count = var.runtime_environment == "develop" || var.runtime_environment == "testing" ? 1 : 0
  family                   = "crypto-listener_base-sepolia-infura"
  network_mode             = "bridge"
  memory                   = 256
  task_role_arn            = aws_iam_role.task_role.arn
  execution_role_arn       = aws_iam_role.task_execution_role.arn
  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }
  container_definitions = jsonencode([
    {
      name  = "listener"
      image = "${data.aws_ecr_repository.repository.repository_url}:${var.image_tag}"
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          "awslogs-create-group"  = "true",
          "awslogs-group"         = "/ecs/crypto-listener/base/sepolia/infura",
          "awslogs-region"        = "ap-southeast-1",
          "awslogs-stream-prefix" = "ecs",
        }
      }
      environment = concat(local.environment_variables, [
        {
          name = "NODE_ID",
          value = "base-sepolia-infura"
        },
        {
          name = "NODE_ECO",
          value = "ethereum"
        },
        {
          name = "NODE_BLOCKCHAIN_ID",
          value = "base-sepolia"
        },
        {
          name = "AWS_CLOUDWATCH_LOG_GROUP_NAME",
          value = "/ecs/crypto-listener/base/sepolia/infura"
        }
      ])
      secrets = concat(local.environment_secrets, [
        {
          name      = "RPC_ENDPOINT"
          valueFrom = "${data.aws_secretsmanager_secret.infura.arn}:BASE_SEPOLIA_JSON_RPC_HTTP_ENDPOINT::"
        }
      ])
    }
  ])
}

# Base Mainnet Task Definitions
resource "aws_ecs_task_definition" "base_infura_task_definition" {
  count = var.runtime_environment == "develop" || var.runtime_environment == "testing" ? 0 : 1
  family                   = "crypto-listener_base-infura"
  network_mode             = "bridge"
  memory                   = 256
  task_role_arn            = aws_iam_role.task_role.arn
  execution_role_arn       = aws_iam_role.task_execution_role.arn
  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }
  container_definitions = jsonencode([
    {
      name  = "listener"
      image = "${data.aws_ecr_repository.repository.repository_url}:${var.image_tag}"
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          "awslogs-create-group"  = "true",
          "awslogs-group"         = "/ecs/crypto-listener/base/mainnet/infura",
          "awslogs-region"        = "ap-southeast-1",
          "awslogs-stream-prefix" = "ecs",
        }
      }
      environment = concat(local.environment_variables, [
        {
          name = "NODE_ID",
          value = "base-infura"
        },
        {
          name = "NODE_ECO",
          value = "ethereum"
        },
        {
          name = "NODE_BLOCKCHAIN_ID",
          value = "base"
        },
        {
          name = "AWS_CLOUDWATCH_LOG_GROUP_NAME",
          value = "/ecs/crypto-listener/base/mainnet/infura"
        }
      ])
      secrets = concat(local.environment_secrets, [
        {
          name      = "RPC_ENDPOINT"
          valueFrom = "${data.aws_secretsmanager_secret.infura.arn}:BASE_MAINNET_JSON_RPC_HTTP_ENDPOINT::"
        }
      ])
    }
  ])
}

# Base Mainnet GetBlock Task Definition
resource "aws_ecs_task_definition" "base_getblock_task_definition" {
  count = var.runtime_environment == "develop" || var.runtime_environment == "testing" ? 0 : 1
  family                   = "crypto-listener_base-getblock"
  network_mode             = "bridge"
  memory                   = 256
  task_role_arn            = aws_iam_role.task_role.arn
  execution_role_arn       = aws_iam_role.task_execution_role.arn
  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }
  container_definitions = jsonencode([
    {
      name  = "listener"
      image = "${data.aws_ecr_repository.repository.repository_url}:${var.image_tag}"
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          "awslogs-create-group"  = "true",
          "awslogs-group"         = "/ecs/crypto-listener/base/mainnet/getblock",
          "awslogs-region"        = "ap-southeast-1",
          "awslogs-stream-prefix" = "ecs",
        }
      }
      environment = concat(local.environment_variables, [
        {
          name = "NODE_ID",
          value = "base-getblock"
        },
        {
          name = "NODE_ECO",
          value = "ethereum"
        },
        {
          name = "NODE_BLOCKCHAIN_ID",
          value = "base"
        },
        {
          name = "AWS_CLOUDWATCH_LOG_GROUP_NAME",
          value = "/ecs/crypto-listener/base/mainnet/getblock"
        }
      ])
      secrets = concat(local.environment_secrets, [
        {
          name      = "RPC_ENDPOINT"
          valueFrom = "${data.aws_secretsmanager_secret.getblock.arn}:BASE_MAINNET_JSON_RPC_HTTP_ENDPOINT::"
        }
      ])
    }
  ])
}

# Base Mainnet DRPC Task Definition
resource "aws_ecs_task_definition" "base_drpc_task_definition" {
  count = var.runtime_environment == "develop" || var.runtime_environment == "testing" ? 0 : 1
  family                   = "crypto-listener_base-drpc"
  network_mode             = "bridge"
  memory                   = 256
  task_role_arn            = aws_iam_role.task_role.arn
  execution_role_arn       = aws_iam_role.task_execution_role.arn
  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }
  container_definitions = jsonencode([
    {
      name  = "listener"
      image = "${data.aws_ecr_repository.repository.repository_url}:${var.image_tag}"
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          "awslogs-create-group"  = "true",
          "awslogs-group"         = "/ecs/crypto-listener/base/mainnet/drpc",
          "awslogs-region"        = "ap-southeast-1",
          "awslogs-stream-prefix" = "ecs",
        }
      }
      environment = concat(local.environment_variables, [
        {
          name = "NODE_ID",
          value = "base-drpc"
        },
        {
          name = "NODE_ECO",
          value = "ethereum"
        },
        {
          name = "NODE_BLOCKCHAIN_ID",
          value = "base"
        },
        {
          name = "AWS_CLOUDWATCH_LOG_GROUP_NAME",
          value = "/ecs/crypto-listener/base/mainnet/drpc"
        }
      ])
      secrets = concat(local.environment_secrets, [
        {
          name      = "RPC_ENDPOINT"
          valueFrom = "${data.aws_secretsmanager_secret.drpc.arn}:BASE_MAINNET_JSON_RPC_HTTP_ENDPOINT::"
        }
      ])
    }
  ])
}

# Base Mainnet QuickNode Task Definition
resource "aws_ecs_task_definition" "base_quicknode_task_definition" {
  count = var.runtime_environment == "develop" || var.runtime_environment == "testing" ? 0 : 1
  family                   = "crypto-listener_base-quicknode"
  network_mode             = "bridge"
  memory                   = 256
  task_role_arn            = aws_iam_role.task_role.arn
  execution_role_arn       = aws_iam_role.task_execution_role.arn
  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }
  container_definitions = jsonencode([
    {
      name  = "listener"
      image = "${data.aws_ecr_repository.repository.repository_url}:${var.image_tag}"
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          "awslogs-create-group"  = "true",
          "awslogs-group"         = "/ecs/crypto-listener/base/mainnet/quicknode",
          "awslogs-region"        = "ap-southeast-1",
          "awslogs-stream-prefix" = "ecs",
        }
      }
      environment = concat(local.environment_variables, [
        {
          name = "NODE_ID",
          value = "base-quicknode"
        },
        {
          name = "NODE_ECO",
          value = "ethereum"
        },
        {
          name = "NODE_BLOCKCHAIN_ID",
          value = "base"
        },
        {
          name = "AWS_CLOUDWATCH_LOG_GROUP_NAME",
          value = "/ecs/crypto-listener/base/mainnet/quicknode"
        }
      ])
      secrets = concat(local.environment_secrets, [
        {
          name      = "RPC_ENDPOINT"
          valueFrom = "${data.aws_secretsmanager_secret.quicknode.arn}:BASE_MAINNET_JSON_RPC_HTTP_ENDPOINT::"
        }
      ])
    }
  ])
}

