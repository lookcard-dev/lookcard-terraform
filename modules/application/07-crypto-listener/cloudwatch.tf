##### Start of TRON NILE #####
resource "aws_cloudwatch_log_group" "tron_nile_trongrid_app_log_group" {
  count = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 0 : 1
  name = "/lookcard/crypto-listener/tron/nile/trongrid"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "tron_nile_trongrid_ecs_log_group" {
  count = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 0 : 1
  name = "/ecs/crypto-listener/tron/nile/trongrid"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "tron_nile_getblock_app_log_group" {
  count = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 0 : 1
  name = "/lookcard/crypto-listener/tron/nile/getblock"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "tron_nile_getblock_ecs_log_group" {
  count = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 0 : 1
  name = "/ecs/crypto-listener/tron/nile/getblock"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

##### End of TRON NILE #####

##### Start of TRON #####
resource "aws_cloudwatch_log_group" "tron_trongrid_app_log_group" {
  count = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 1 : 0
  name = "/lookcard/crypto-listener/tron/mainnet/trongrid"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "tron_trongrid_ecs_log_group" {
  count = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 1 : 0
  name = "/ecs/crypto-listener/tron/mainnet/trongrid"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "tron_getblock_app_log_group" {
  count = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 1 : 0
  name = "/lookcard/crypto-listener/tron/mainnet/getblock"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "tron_getblock_ecs_log_group" {
  count = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 1 : 0
  name = "/ecs/crypto-listener/tron/mainnet/getblock"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "tron_drpc_app_log_group" {
  count = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 1 : 0
  name = "/lookcard/crypto-listener/tron/mainnet/drpc"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "tron_drpc_ecs_log_group" {
  count = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 1 : 0
  name = "/ecs/crypto-listener/tron/mainnet/drpc"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "tron_quicknode_app_log_group" {
  count = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 1 : 0
  name = "/lookcard/crypto-listener/tron/mainnet/quicknode"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "tron_quicknode_ecs_log_group" {
  count = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 1 : 0
  name = "/ecs/crypto-listener/tron/mainnet/quicknode"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

##### End of TRON #####

##### Start of BSC Testnet #####
resource "aws_cloudwatch_log_group" "bsc_testnet_infura_app_log_group" {
  count = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 0 : 1
  name = "/lookcard/crypto-listener/bsc/testnet/infura"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "bsc_testnet_infura_ecs_log_group" {
  count = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 0 : 1
  name = "/ecs/crypto-listener/bsc/testnet/infura"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "bsc_testnet_getblock_app_log_group" {
  count = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 0 : 1
  name = "/lookcard/crypto-listener/bsc/testnet/getblock"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "bsc_testnet_getblock_ecs_log_group" {
  count = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 0 : 1
  name = "/ecs/crypto-listener/bsc/testnet/getblock"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "bsc_testnet_drpc_app_log_group" {
  count = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 0 : 1
  name = "/lookcard/crypto-listener/bsc/testnet/drpc"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "bsc_testnet_drpc_ecs_log_group" {
  count = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 0 : 1
  name = "/ecs/crypto-listener/bsc/testnet/drpc"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "bsc_testnet_quicknode_app_log_group" {
  count = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 0 : 1
  name = "/lookcard/crypto-listener/bsc/testnet/quicknode"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "bsc_testnet_quicknode_ecs_log_group" {
  count = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 0 : 1
  name = "/ecs/crypto-listener/bsc/testnet/quicknode"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

##### End of BSC Testnet #####

##### Start of BSC #####
resource "aws_cloudwatch_log_group" "bsc_infura_app_log_group" {
  count = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 1 : 0
  name = "/lookcard/crypto-listener/bsc/mainnet/infura"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "bsc_infura_ecs_log_group" {
  count = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 1 : 0
  name = "/ecs/crypto-listener/bsc/mainnet/infura"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "bsc_getblock_app_log_group" {
  count = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 1 : 0
  name = "/lookcard/crypto-listener/bsc/mainnet/getblock"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "bsc_getblock_ecs_log_group" {
  count = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 1 : 0
  name = "/ecs/crypto-listener/bsc/mainnet/getblock"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "bsc_drpc_app_log_group" {
  count = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 1 : 0
  name = "/lookcard/crypto-listener/bsc/mainnet/drpc"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "bsc_drpc_ecs_log_group" {
  count = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 1 : 0
  name = "/ecs/crypto-listener/bsc/mainnet/drpc"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "bsc_quicknode_app_log_group" {
  count = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 1 : 0
  name = "/lookcard/crypto-listener/bsc/mainnet/quicknode"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "bsc_quicknode_ecs_log_group" {
  count = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 1 : 0
  name = "/ecs/crypto-listener/bsc/mainnet/quicknode"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}
##### End of BSC #####

##### Start of Polygon Amoy #####
resource "aws_cloudwatch_log_group" "polygon_amoy_infura_app_log_group" {
  count = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 0 : 1
  name = "/lookcard/crypto-listener/polygon/amoy/infura"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "polygon_amoy_infura_ecs_log_group" {
  count = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 0 : 1
  name = "/ecs/crypto-listener/polygon/amoy/infura"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "polygon_amoy_getblock_app_log_group" {
  count = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 0 : 1
  name = "/lookcard/crypto-listener/polygon/amoy/getblock"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "polygon_amoy_getblock_ecs_log_group" {
  count = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 0 : 1
  name = "/ecs/crypto-listener/polygon/amoy/getblock"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "polygon_amoy_drpc_app_log_group" {
  count = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 0 : 1
  name = "/lookcard/crypto-listener/polygon/amoy/drpc"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "polygon_amoy_drpc_ecs_log_group" {
  count = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 0 : 1
  name = "/ecs/crypto-listener/polygon/amoy/drpc"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "polygon_amoy_quicknode_app_log_group" {
  count = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 0 : 1
  name = "/lookcard/crypto-listener/polygon/amoy/quicknode"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "polygon_amoy_quicknode_ecs_log_group" {
  count = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 0 : 1
  name = "/ecs/crypto-listener/polygon/amoy/quicknode"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}
##### End of Polygon Amoy#####

##### Start of Polygon #####
resource "aws_cloudwatch_log_group" "polygon_infura_app_log_group" {
  count = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 1 : 0
  name = "/lookcard/crypto-listener/polygon/mainnet/infura"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "polygon_infura_ecs_log_group" {
  count = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 1 : 0
  name = "/ecs/crypto-listener/polygon/mainnet/infura"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "polygon_getblock_app_log_group" {
  count = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 1 : 0
  name = "/lookcard/crypto-listener/polygon/mainnet/getblock"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "polygon_getblock_ecs_log_group" {
  count = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 1 : 0
  name = "/ecs/crypto-listener/polygon/mainnet/getblock"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "polygon_drpc_app_log_group" {
  count = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 1 : 0
  name = "/lookcard/crypto-listener/polygon/mainnet/drpc"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "polygon_drpc_ecs_log_group" {
  count = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 1 : 0
  name = "/ecs/crypto-listener/polygon/mainnet/drpc"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "polygon_quicknode_app_log_group" {
  count = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 1 : 0
  name = "/lookcard/crypto-listener/polygon/mainnet/quicknode"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "polygon_quicknode_ecs_log_group" {
  count = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 1 : 0
  name = "/ecs/crypto-listener/polygon/mainnet/quicknode"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}
##### End of Polygon #####

##### Start of Avalanche Fuji #####
resource "aws_cloudwatch_log_group" "avalanche_fuji_infura_app_log_group" {
  count = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 0 : 1
  name = "/lookcard/crypto-listener/avalanche/fuji/infura"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "avalanche_fuji_infura_ecs_log_group" {
  count = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 0 : 1
  name = "/ecs/crypto-listener/avalanche/fuji/infura"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "avalanche_fuji_getblock_app_log_group" {
  count = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 0 : 1
  name = "/lookcard/crypto-listener/avalanche/fuji/getblock"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "avalanche_fuji_getblock_ecs_log_group" {
  count = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 0 : 1
  name = "/ecs/crypto-listener/avalanche/fuji/getblock"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "avalanche_fuji_drpc_app_log_group" {
  count = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 0 : 1
  name = "/lookcard/crypto-listener/avalanche/fuji/drpc"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "avalanche_fuji_drpc_ecs_log_group" {
  count = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 0 : 1
  name = "/ecs/crypto-listener/avalanche/fuji/drpc"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "avalanche_fuji_quicknode_app_log_group" {
  count = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 0 : 1
  name = "/lookcard/crypto-listener/avalanche/fuji/quicknode"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "avalanche_fuji_quicknode_ecs_log_group" {
  count = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 0 : 1
  name = "/ecs/crypto-listener/avalanche/fuji/quicknode"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}
##### End of Avalanche Fuji#####

##### Start of Avalanche #####
resource "aws_cloudwatch_log_group" "avalanche_infura_app_log_group" {
  count = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 1 : 0
  name = "/lookcard/crypto-listener/avalanche/mainnet/infura"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "avalanche_infura_ecs_log_group" {
  count = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 1 : 0
  name = "/ecs/crypto-listener/avalanche/mainnet/infura"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "avalanche_getblock_app_log_group" {
  count = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 1 : 0
  name = "/lookcard/crypto-listener/avalanche/mainnet/getblock"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "avalanche_getblock_ecs_log_group" {
  count = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 1 : 0
  name = "/ecs/crypto-listener/avalanche/mainnet/getblock"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "avalanche_drpc_app_log_group" {
  count = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 1 : 0
  name = "/lookcard/crypto-listener/avalanche/mainnet/drpc"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "avalanche_drpc_ecs_log_group" {
  count = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 1 : 0
  name = "/ecs/crypto-listener/avalanche/mainnet/drpc"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "avalanche_quicknode_app_log_group" {
  count = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 1 : 0
  name = "/lookcard/crypto-listener/avalanche/mainnet/quicknode"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "avalanche_quicknode_ecs_log_group" {
  count = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 1 : 0
  name = "/ecs/crypto-listener/avalanche/mainnet/quicknode"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}
##### End of Avalanche #####

##### Start of Optimism Sepolia #####
resource "aws_cloudwatch_log_group" "optimism_sepolia_infura_app_log_group" {
  count = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 0 : 1
  name = "/lookcard/crypto-listener/optimism/sepolia/infura"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "optimism_sepolia_infura_ecs_log_group" {
  count = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 0 : 1
  name = "/ecs/crypto-listener/optimism/sepolia/infura"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "optimism_sepolia_getblock_app_log_group" {
  count = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 0 : 1
  name = "/lookcard/crypto-listener/optimism/sepolia/getblock"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "optimism_sepolia_getblock_ecs_log_group" {
  count = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 0 : 1
  name = "/ecs/crypto-listener/optimism/sepolia/getblock"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "optimism_sepolia_drpc_app_log_group" {
  count = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 0 : 1
  name = "/lookcard/crypto-listener/optimism/sepolia/drpc"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "optimism_sepolia_drpc_ecs_log_group" {
  count = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 0 : 1
  name = "/ecs/crypto-listener/optimism/sepolia/drpc"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "optimism_sepolia_quicknode_app_log_group" {
  count = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 0 : 1
  name = "/lookcard/crypto-listener/optimism/sepolia/quicknode"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "optimism_sepolia_quicknode_ecs_log_group" {
  count = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 0 : 1
  name = "/ecs/crypto-listener/optimism/sepolia/quicknode"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}
##### End of Optimism Sepolia ##### 

##### Start of Optimism #####
resource "aws_cloudwatch_log_group" "optimism_infura_app_log_group" {
  count = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 1 : 0
  name = "/lookcard/crypto-listener/optimism/mainnet/infura"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "optimism_infura_ecs_log_group" {
  count = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 1 : 0
  name = "/ecs/crypto-listener/optimism/mainnet/infura"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "optimism_getblock_app_log_group" {
  count = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 1 : 0
  name = "/lookcard/crypto-listener/optimism/mainnet/getblock"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "optimism_getblock_ecs_log_group" {
  count = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 1 : 0
  name = "/ecs/crypto-listener/optimism/mainnet/getblock"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "optimism_drpc_app_log_group" {
  count = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 1 : 0
  name = "/lookcard/crypto-listener/optimism/mainnet/drpc"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "optimism_drpc_ecs_log_group" {
  count = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 1 : 0
  name = "/ecs/crypto-listener/optimism/mainnet/drpc"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "optimism_quicknode_app_log_group" {
  count = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 1 : 0
  name = "/lookcard/crypto-listener/optimism/mainnet/quicknode"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "optimism_quicknode_ecs_log_group" {
  count = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 1 : 0
  name = "/ecs/crypto-listener/optimism/mainnet/quicknode"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}
##### End of Optimism ##### 

##### Start of Arbitrum Sepolia #####
resource "aws_cloudwatch_log_group" "arbitrum_sepolia_infura_app_log_group" {
  count = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 0 : 1
  name = "/lookcard/crypto-listener/arbitrum/sepolia/infura"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "arbitrum_sepolia_infura_ecs_log_group" {
  count = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 0 : 1
  name = "/ecs/crypto-listener/arbitrum/sepolia/infura"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "arbitrum_sepolia_getblock_app_log_group" {
  count = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 0 : 1
  name = "/lookcard/crypto-listener/arbitrum/sepolia/getblock"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "arbitrum_sepolia_getblock_ecs_log_group" {
  count = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 0 : 1
  name = "/ecs/crypto-listener/arbitrum/sepolia/getblock"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "arbitrum_sepolia_drpc_app_log_group" {
  count = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 0 : 1
  name = "/lookcard/crypto-listener/arbitrum/sepolia/drpc"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "arbitrum_sepolia_drpc_ecs_log_group" {
  count = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 0 : 1
  name = "/ecs/crypto-listener/arbitrum/sepolia/drpc"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "arbitrum_sepolia_quicknode_app_log_group" {
  count = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 0 : 1
  name = "/lookcard/crypto-listener/arbitrum/sepolia/quicknode"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "arbitrum_sepolia_quicknode_ecs_log_group" {
  count = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 0 : 1
  name = "/ecs/crypto-listener/arbitrum/sepolia/quicknode"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}
##### End of Arbitrum Sepolia ##### 

##### Start of Arbitrum #####
resource "aws_cloudwatch_log_group" "arbitrum_infura_app_log_group" {
  count = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 1 : 0
  name = "/lookcard/crypto-listener/arbitrum/mainnet/infura"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "arbitrum_infura_ecs_log_group" {
  count = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 1 : 0
  name = "/ecs/crypto-listener/arbitrum/mainnet/infura"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "arbitrum_getblock_app_log_group" {
  count = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 1 : 0
  name = "/lookcard/crypto-listener/arbitrum/mainnet/getblock"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "arbitrum_getblock_ecs_log_group" {
  count = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 1 : 0
  name = "/ecs/crypto-listener/arbitrum/mainnet/getblock"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "arbitrum_drpc_app_log_group" {
  count = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 1 : 0
  name = "/lookcard/crypto-listener/arbitrum/mainnet/drpc"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "arbitrum_drpc_ecs_log_group" {
  count = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 1 : 0
  name = "/ecs/crypto-listener/arbitrum/mainnet/drpc"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "arbitrum_quicknode_app_log_group" {
  count = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 1 : 0
  name = "/lookcard/crypto-listener/arbitrum/mainnet/quicknode"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "arbitrum_quicknode_ecs_log_group" {
  count = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 1 : 0
  name = "/ecs/crypto-listener/arbitrum/mainnet/quicknode"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}
##### End of Arbitrum ##### 

##### Start of Base Sepolia #####
resource "aws_cloudwatch_log_group" "base_sepolia_getblock_app_log_group" {
  count = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 0 : 1
  name = "/lookcard/crypto-listener/base/sepolia/getblock"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "base_sepolia_getblock_ecs_log_group" {
  count = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 0 : 1
  name = "/ecs/crypto-listener/base/sepolia/getblock"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "base_sepolia_drpc_app_log_group" {
  count = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 0 : 1
  name = "/lookcard/crypto-listener/base/sepolia/drpc"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "base_sepolia_drpc_ecs_log_group" {
  count = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 0 : 1
  name = "/ecs/crypto-listener/base/sepolia/drpc"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "base_sepolia_quicknode_app_log_group" {
  count = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 0 : 1
  name = "/lookcard/crypto-listener/base/sepolia/quicknode"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "base_sepolia_quicknode_ecs_log_group" {
  count = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 0 : 1
  name = "/ecs/crypto-listener/base/sepolia/quicknode"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}
##### End of Base Sepolia #####

##### Start of Base #####
resource "aws_cloudwatch_log_group" "base_getblock_app_log_group" {
  count = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 1 : 0
  name = "/lookcard/crypto-listener/base/mainnet/getblock"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "base_getblock_ecs_log_group" {
  count = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 1 : 0
  name = "/ecs/crypto-listener/base/mainnet/getblock"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "base_drpc_app_log_group" {
  count = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 1 : 0
  name = "/lookcard/crypto-listener/base/mainnet/drpc"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "base_drpc_ecs_log_group" {
  count = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 1 : 0
  name = "/ecs/crypto-listener/base/mainnet/drpc"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "base_quicknode_app_log_group" {
  count = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 1 : 0
  name = "/lookcard/crypto-listener/base/mainnet/quicknode"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "base_quicknode_ecs_log_group" {
  count = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 1 : 0
  name = "/ecs/crypto-listener/base/mainnet/quicknode"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}
##### End of Base #####