resource "aws_ecs_service" "tron_nile_trongrid_ecs_service" {
  count           = var.runtime_environment == "develop" || var.runtime_environment == "testing" ? 1 : 0
  name            = "tron-nile_trongrid"
  task_definition = aws_ecs_task_definition.tron_nile_trongrid_task_definition[0].arn
  desired_count   = var.image_tag == "latest" ? 0 : 1
  cluster         = var.cluster_id
  capacity_provider_strategy {
    capacity_provider = "LISTENER_EC2_ARM64"
    weight            = 1
  }
  ordered_placement_strategy {
    type  = "spread"
    field = "instanceId"
  }
}

resource "aws_ecs_service" "tron_nile_getblock_ecs_service" {
  count           = var.runtime_environment == "develop" || var.runtime_environment == "testing" ? 1 : 0
  name            = "tron-nile_getblock"
  task_definition = aws_ecs_task_definition.tron_nile_getblock_task_definition[0].arn
  desired_count   = var.image_tag == "latest" ? 0 : 1
  cluster         = var.cluster_id
  capacity_provider_strategy {
    capacity_provider = "LISTENER_EC2_ARM64"
    weight            = 1
  }
  ordered_placement_strategy {
    type  = "spread"
    field = "instanceId"
  }
}

resource "aws_ecs_service" "ethereum_sepolia_getblock_ecs_service" {
  count           = var.runtime_environment == "develop" || var.runtime_environment == "testing" ? 1 : 0
  name            = "ethereum-sepolia_getblock"
  task_definition = aws_ecs_task_definition.ethereum_sepolia_getblock_task_definition[0].arn
  desired_count   = var.image_tag == "latest" ? 0 : 1
  cluster         = var.cluster_id
  capacity_provider_strategy {
    capacity_provider = "LISTENER_EC2_ARM64"
    weight            = 1
  }
  ordered_placement_strategy {
    type  = "spread"
    field = "instanceId"
  }
}

resource "aws_ecs_service" "bsc_testnet_getblock_ecs_service" {
  count           = var.runtime_environment == "develop" || var.runtime_environment == "testing" ? 1 : 0
  name            = "bsc-testnet_getblock"
  task_definition = aws_ecs_task_definition.bsc_testnet_getblock_task_definition[0].arn
  desired_count   = var.image_tag == "latest" ? 0 : 1
  cluster         = var.cluster_id
  capacity_provider_strategy {
    capacity_provider = "LISTENER_EC2_ARM64"
    weight            = 1
  }
  ordered_placement_strategy {
    type  = "spread"
    field = "instanceId"
  }
}

resource "aws_ecs_service" "base_sepolia_getblock_ecs_service" {
  count           = var.runtime_environment == "develop" || var.runtime_environment == "testing" ? 1 : 0
  name            = "base-sepolia_getblock"
  task_definition = aws_ecs_task_definition.base_sepolia_getblock_task_definition[0].arn
  desired_count   = var.image_tag == "latest" ? 0 : 1
  cluster         = var.cluster_id
  capacity_provider_strategy {
    capacity_provider = "LISTENER_EC2_ARM64"
    weight            = 1
  }
  ordered_placement_strategy {
    type  = "spread"
    field = "instanceId"
  }
}

resource "aws_ecs_service" "optimism_sepolia_blast_ecs_service" {
  count           = var.runtime_environment == "develop" || var.runtime_environment == "testing" ? 1 : 0
  name            = "optimism-sepolia_blast"
  task_definition = aws_ecs_task_definition.optimism_sepolia_blast_task_definition[0].arn
  desired_count   = var.image_tag == "latest" ? 0 : 1
  cluster         = var.cluster_id
  capacity_provider_strategy {
    capacity_provider = "LISTENER_EC2_ARM64"
    weight            = 1
  }
  ordered_placement_strategy {
    type  = "spread"
    field = "instanceId"
  }
}

resource "aws_ecs_service" "ethereum_sepolia_publicnode_ecs_service" {
  count           = var.runtime_environment == "develop" || var.runtime_environment == "testing" ? 1 : 0
  name            = "ethereum-sepolia_publicnode"
  task_definition = aws_ecs_task_definition.ethereum_sepolia_publicnode_task_definition[0].arn
  desired_count   = var.image_tag == "latest" ? 0 : 1
  cluster         = var.cluster_id
  capacity_provider_strategy {
    capacity_provider = "LISTENER_EC2_ARM64"
    weight            = 1
  }
  ordered_placement_strategy {
    type  = "spread"
    field = "instanceId"
  }
}

resource "aws_ecs_service" "bsc_testnet_publicnode_ecs_service" {
  count           = var.runtime_environment == "develop" || var.runtime_environment == "testing" ? 1 : 0
  name            = "bsc-testnet_publicnode"
  task_definition = aws_ecs_task_definition.bsc_testnet_publicnode_task_definition[0].arn
  desired_count   = var.image_tag == "latest" ? 0 : 1
  cluster         = var.cluster_id
  capacity_provider_strategy {
    capacity_provider = "LISTENER_EC2_ARM64"
    weight            = 1
  }
  ordered_placement_strategy {
    type  = "spread"
    field = "instanceId"
  }
}

resource "aws_ecs_service" "base_sepolia_publicnode_ecs_service" {
  count           = var.runtime_environment == "develop" || var.runtime_environment == "testing" ? 1 : 0
  name            = "base-sepolia_publicnode"
  task_definition = aws_ecs_task_definition.base_sepolia_publicnode_task_definition[0].arn
  desired_count   = var.image_tag == "latest" ? 0 : 1
  cluster         = var.cluster_id
  capacity_provider_strategy {
    capacity_provider = "LISTENER_EC2_ARM64"
    weight            = 1
  }
  ordered_placement_strategy {
    type  = "spread"
    field = "instanceId"
  }
}

resource "aws_ecs_service" "optimism_sepolia_publicnode_ecs_service" {
  count           = var.runtime_environment == "develop" || var.runtime_environment == "testing" ? 1 : 0
  name            = "optimism-sepolia_publicnode"
  task_definition = aws_ecs_task_definition.optimism_sepolia_publicnode_task_definition[0].arn
  desired_count   = var.image_tag == "latest" ? 0 : 1
  cluster         = var.cluster_id
  capacity_provider_strategy {
    capacity_provider = "LISTENER_EC2_ARM64"
    weight            = 1
  }
  ordered_placement_strategy {
    type  = "spread"
    field = "instanceId"
  }
}

# resource "aws_ecs_service" "solana_testnet_publicnode_ecs_service" {
#   count           = var.runtime_environment == "develop" || var.runtime_environment == "testing" ? 1 : 0
#   name            = "solana-testnet_publicnode"
#   task_definition = aws_ecs_task_definition.solana_testnet_publicnode_task_definition[0].arn
#   desired_count   = var.image_tag == "latest" ? 0 : 1
#   cluster         = var.cluster_id
#   capacity_provider_strategy {
#     capacity_provider = "LISTENER_EC2_ARM64"
#     weight            = 1
#   }
#   ordered_placement_strategy {
#     type  = "spread"
#     field = "instanceId"
#   }
# }

# Mainnet Services

# Tron Mainnet Services
resource "aws_ecs_service" "tron_trongrid_ecs_service" {
  count           = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 0 : 0
  name            = "tron_trongrid"
  task_definition = aws_ecs_task_definition.tron_trongrid_task_definition[0].arn
  desired_count   = var.image_tag == "latest" ? 0 : 1
  cluster         = var.cluster_id
  capacity_provider_strategy {
    capacity_provider = "LISTENER_EC2_ARM64"
    weight            = 1
  }
  ordered_placement_strategy {
    type  = "spread"
    field = "instanceId"
  }
}

resource "aws_ecs_service" "tron_getblock_ecs_service" {
  count           = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 1 : 0
  name            = "tron_getblock"
  task_definition = aws_ecs_task_definition.tron_getblock_task_definition[0].arn
  desired_count   = var.image_tag == "latest" ? 0 : 1
  cluster         = var.cluster_id
  capacity_provider_strategy {
    capacity_provider = "LISTENER_EC2_ARM64"
    weight            = 1
  }
  ordered_placement_strategy {
    type  = "spread"
    field = "instanceId"
  }
}

resource "aws_ecs_service" "tron_publicnode_ecs_service" {
  count           = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 0 : 0
  name            = "tron_publicnode"
  task_definition = aws_ecs_task_definition.tron_publicnode_task_definition[0].arn
  desired_count   = var.image_tag == "latest" ? 0 : 1
  cluster         = var.cluster_id
  capacity_provider_strategy {
    capacity_provider = "LISTENER_EC2_ARM64"
    weight            = 1
  }
  ordered_placement_strategy {
    type  = "spread"
    field = "instanceId"
  }
}

# BSC Mainnet Services
resource "aws_ecs_service" "bsc_getblock_ecs_service" {
  count           = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 0 : 0
  name            = "bsc_getblock"
  task_definition = aws_ecs_task_definition.bsc_getblock_task_definition[0].arn
  desired_count   = var.image_tag == "latest" ? 0 : 1
  cluster         = var.cluster_id
  capacity_provider_strategy {
    capacity_provider = "LISTENER_EC2_ARM64"
    weight            = 1
  }
  ordered_placement_strategy {
    type  = "spread"
    field = "instanceId"
  }
}

resource "aws_ecs_service" "bsc_publicnode_ecs_service" {
  count           = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 1 : 0
  name            = "bsc_publicnode"
  task_definition = aws_ecs_task_definition.bsc_publicnode_task_definition[0].arn
  desired_count   = var.image_tag == "latest" ? 0 : 1
  cluster         = var.cluster_id
  capacity_provider_strategy {
    capacity_provider = "LISTENER_EC2_ARM64"
    weight            = 1
  }
  ordered_placement_strategy {
    type  = "spread"
    field = "instanceId"
  }
}

resource "aws_ecs_service" "bsc_blast_ecs_service" {
  count           = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 1 : 0
  name            = "bsc_blast"
  task_definition = aws_ecs_task_definition.bsc_blast_task_definition[0].arn
  desired_count   = var.image_tag == "latest" ? 0 : 1
  cluster         = var.cluster_id
  capacity_provider_strategy {
    capacity_provider = "LISTENER_EC2_ARM64"
    weight            = 1
  }
  ordered_placement_strategy {
    type  = "spread"
    field = "instanceId"
  }
}

# Base Mainnet Services
resource "aws_ecs_service" "base_getblock_ecs_service" {
  count           = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 0 : 0
  name            = "base_getblock"
  task_definition = aws_ecs_task_definition.base_getblock_task_definition[0].arn
  desired_count   = var.image_tag == "latest" ? 0 : 1
  cluster         = var.cluster_id
  capacity_provider_strategy {
    capacity_provider = "LISTENER_EC2_ARM64"
    weight            = 1
  }
  ordered_placement_strategy {
    type  = "spread"
    field = "instanceId"
  }
}

resource "aws_ecs_service" "base_publicnode_ecs_service" {
  count           = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 1 : 0
  name            = "base_publicnode"
  task_definition = aws_ecs_task_definition.base_publicnode_task_definition[0].arn
  desired_count   = var.image_tag == "latest" ? 0 : 1
  cluster         = var.cluster_id
  capacity_provider_strategy {
    capacity_provider = "LISTENER_EC2_ARM64"
    weight            = 1
  }
  ordered_placement_strategy {
    type  = "spread"
    field = "instanceId"
  }
}

resource "aws_ecs_service" "base_blast_ecs_service" {
  count           = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 1 : 0
  name            = "base_blast"
  task_definition = aws_ecs_task_definition.base_blast_task_definition[0].arn
  desired_count   = var.image_tag == "latest" ? 0 : 1
  cluster         = var.cluster_id
  capacity_provider_strategy {
    capacity_provider = "LISTENER_EC2_ARM64"
    weight            = 1
  }
  ordered_placement_strategy {
    type  = "spread"
    field = "instanceId"
  }
}

# Optimism Mainnet Services
resource "aws_ecs_service" "optimism_getblock_ecs_service" {
  count           = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 0 : 0
  name            = "optimism_getblock"
  task_definition = aws_ecs_task_definition.optimism_getblock_task_definition[0].arn
  desired_count   = var.image_tag == "latest" ? 0 : 1
  cluster         = var.cluster_id
  capacity_provider_strategy {
    capacity_provider = "LISTENER_EC2_ARM64"
    weight            = 1
  }
  ordered_placement_strategy {
    type  = "spread"
    field = "instanceId"
  }
}

resource "aws_ecs_service" "optimism_publicnode_ecs_service" {
  count           = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 1 : 0
  name            = "optimism_publicnode"
  task_definition = aws_ecs_task_definition.optimism_publicnode_task_definition[0].arn
  desired_count   = var.image_tag == "latest" ? 0 : 1
  cluster         = var.cluster_id
  capacity_provider_strategy {
    capacity_provider = "LISTENER_EC2_ARM64"
    weight            = 1
  }
  ordered_placement_strategy {
    type  = "spread"
    field = "instanceId"
  }
}

resource "aws_ecs_service" "optimism_blast_ecs_service" {
  count           = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 1 : 0
  name            = "optimism_blast"
  task_definition = aws_ecs_task_definition.optimism_blast_task_definition[0].arn
  desired_count   = var.image_tag == "latest" ? 0 : 1
  cluster         = var.cluster_id
  capacity_provider_strategy {
    capacity_provider = "LISTENER_EC2_ARM64"
    weight            = 1
  }
  ordered_placement_strategy {
    type  = "spread"
    field = "instanceId"
  }
}
