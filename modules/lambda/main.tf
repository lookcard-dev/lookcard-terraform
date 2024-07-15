module "aggregator-tron" {
  source              = "./aggregator-tron"
  network = {
    vpc            = var.network.vpc
    private_subnet = var.network.private_subnet
    public_subnet  = var.network.public_subnet
  }
  sqs              = var.sqs
  secret_manager   = var.secret_manager
}

module "crypto-fundwithdrawal" {
  source              = "./crypto-fundwithdrawal"
  sqs              = var.sqs
  network = {
    vpc            = var.network.vpc
    private_subnet = var.network.private_subnet
    public_subnet  = var.network.public_subnet
  }
  secret_manager   = var.secret_manager
}

module "data-process" {
  source              = "./data-process"
  secret_manager               = var.secret_manager
  lambda_code                  = var.lambda_code
}


module "eliptic" {
  source              = "./eliptic"
  sqs              = var.sqs
  network = {
    vpc            = var.network.vpc
    private_subnet = var.network.private_subnet
    public_subnet  = var.network.public_subnet
  }
  lambda_code      = var.lambda_code
  secret_manager   = var.secret_manager
}

module "lookcard-notification" {
  source              = "./lookcard-notification"
  sqs              = var.sqs
  network = {
    vpc            = var.network.vpc
    private_subnet = var.network.private_subnet
    public_subnet  = var.network.public_subnet
  }
  secret_manager   = var.secret_manager
}

module "lookcard-websocket" {
  source              = "./lookcard-websocket"
  sqs                 = var.sqs
  secret_manager      = var.secret_manager
}

module "lookcard-pushnoification" {
  source              = "./lookcard-pushnoification"
  network = {
    vpc            = var.network.vpc
    private_subnet = var.network.private_subnet
    public_subnet  = var.network.public_subnet
  }
  secret_manager   = var.secret_manager
}

module "websocket-connect" {
  source              = "./websocket-connect"
  ddb_websocket_arn   = var.ddb_websocket_arn
  lambda_code         = var.lambda_code
}

module "websocket-disconnect" {
  source              = "./websocket-disconnect"
  ddb_websocket_arn   = var.ddb_websocket_arn
  lambda_code         = var.lambda_code
}