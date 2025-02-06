terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      configuration_aliases = [aws.dns]
    }
  }
}

module "xray-daemon" {
  source = "./00-xray-daemon"
  aws_provider = var.aws_provider
  name = "xray-daemon"
  runtime_environment = var.runtime_environment
  cluster_id = var.cluster_ids.core_application
  namespace_id = var.namespace_id
  network = var.network
}

module "profile-api" {
  source = "./01-profile-api"
  aws_provider = var.aws_provider
  name = "profile-api"
  image_tag = var.components["profile-api"].image_tag
  runtime_environment = var.runtime_environment
  cluster_id = var.cluster_ids.core_application
  namespace_id = var.namespace_id
  network = var.network
  allow_to_security_group_ids = []
}

module "data-api" {
  source = "./02-data-api"
  aws_provider = var.aws_provider
  name = "data-api"
  image_tag = var.components["data-api"].image_tag
  runtime_environment = var.runtime_environment
  cluster_id = var.cluster_ids.core_application
  namespace_id = var.namespace_id
  network = var.network
  allow_to_security_group_ids = []
  kms_key_arns = var.kms_key_arns
}

module "config-api" {
  source = "./03-config-api"
  aws_provider = var.aws_provider
  name = "config-api"
  image_tag = var.components["config-api"].image_tag
  runtime_environment = var.runtime_environment
  cluster_id = var.cluster_ids.core_application
  namespace_id = var.namespace_id
  network = var.network
  allow_to_security_group_ids = []
}

module "user-api" {
  source = "./04-user-api"
  aws_provider = var.aws_provider
  name = "user-api"
  image_tag = var.components["user-api"].image_tag
  runtime_environment = var.runtime_environment
  cluster_id = var.cluster_ids.core_application
  namespace_id = var.namespace_id
  network = var.network
  allow_to_security_group_ids = [
    module.profile-api.security_group_id,
    module.data-api.security_group_id
  ]
  datacache = var.datacache
  datastore = var.datastore
}

module "account-api" {
  source = "./05-account-api"
  aws_provider = var.aws_provider
  name = "account-api"
  image_tag = var.components["account-api"].image_tag
  runtime_environment = var.runtime_environment
  cluster_id = var.cluster_ids.core_application
  namespace_id = var.namespace_id
  network = var.network
  allow_to_security_group_ids = [
    module.config-api.security_group_id,
    module.profile-api.security_group_id,
    module.data-api.security_group_id
  ]
  datacache = var.datacache
  datastore = var.datastore
}

module "crypto-api" {
  source = "./06-crypto-api"
  aws_provider = var.aws_provider
  name = "crypto-api"
  image_tag = var.components["crypto-api"].image_tag
  runtime_environment = var.runtime_environment
  cluster_id = var.cluster_ids.core_application
  namespace_id = var.namespace_id
  network = var.network
  allow_to_security_group_ids = [
    module.config-api.security_group_id,
    module.profile-api.security_group_id,
    module.data-api.security_group_id,
    module.account-api.security_group_id
  ]
  datacache = var.datacache
  datastore = var.datastore
  kms_key_arns = var.kms_key_arns
}

module "crypto-listener" {
  source = "./07-crypto-listener"
  aws_provider = var.aws_provider
  name = "crypto-listener"
  image_tag = var.components["crypto-listener"].image_tag
  runtime_environment = var.runtime_environment
  cluster_id = var.cluster_ids.listener
  network = var.network
  allow_to_security_group_ids = [
    module.crypto-api.security_group_id
  ]
  datastore = var.datastore
  datacache = var.datacache
}

module "crypto-processor" {
  source = "./08-crypto-processor"
  aws_provider = var.aws_provider
  name = "crypto-processor"
  image_tag = var.components["crypto-processor"].image_tag
  runtime_environment = var.runtime_environment
  network = var.network
  allow_to_security_group_ids = [
    module.crypto-api.security_group_id,
    module.account-api.security_group_id,
    module.profile-api.security_group_id,
    module.config-api.security_group_id
  ]
}

module "authentication-api" {
  source = "./09-authentication-api"
  aws_provider = var.aws_provider
  name = "authentication-api"
  image_tag = var.components["authentication-api"].image_tag
  runtime_environment = var.runtime_environment
  cluster_id = var.cluster_ids.core_application
  namespace_id = var.namespace_id
  network = var.network
  allow_to_security_group_ids = [
    module.profile-api.security_group_id
  ]
}

module "verification-api" {
  source = "./10-verification-api"
  aws_provider = var.aws_provider
  name = "verification-api"
  image_tag = var.components["verification-api"].image_tag
  runtime_environment = var.runtime_environment
  cluster_id = var.cluster_ids.core_application
  namespace_id = var.namespace_id
  network = var.network
  allow_to_security_group_ids = [
    module.data-api.security_group_id,
  ]
  datacache = var.datacache
  datastore = var.datastore
}

module "notification-api" {
  source = "./11-notification-api"
  aws_provider = var.aws_provider
  name = "notification-api"
  image_tag = var.components["notification-api"].image_tag
  runtime_environment = var.runtime_environment
  cluster_id = var.cluster_ids.core_application
  namespace_id = var.namespace_id
  network = var.network
  allow_to_security_group_ids = []
}

module "referral-api" {
  source = "./12-referral-api"
  aws_provider = var.aws_provider
  name = "referral-api"
  image_tag = var.components["referral-api"].image_tag
  runtime_environment = var.runtime_environment
  cluster_id = var.cluster_ids.core_application
  namespace_id = var.namespace_id
  network = var.network
  allow_to_security_group_ids = []
  datastore = var.datastore
  datacache = var.datacache
}

module "domain-api" {
  source = "./13-domain-api"
  aws_provider = var.aws_provider
  name = "domain-api"
  image_tag = var.components["domain-api"].image_tag
  runtime_environment = var.runtime_environment
  cluster_id = var.cluster_ids.core_application
  namespace_id = var.namespace_id
  network = var.network
  allow_to_security_group_ids = []
}

module "reseller-api" {
  source = "./14-reseller-api"
  aws_provider = var.aws_provider
  name = "reseller-api"
  image_tag = var.components["reseller-api"].image_tag
  runtime_environment = var.runtime_environment
  cluster_id = var.cluster_ids.composite_application
  namespace_id = var.namespace_id
  network = var.network
  allow_to_security_group_ids = []
  datastore = var.datastore
  datacache = var.datacache
}

module "reap-proxy" {
  source = "./15-reap-proxy"
  aws_provider = var.aws_provider
  name = "reap-proxy"
  image_tag = var.components["reap-proxy"].image_tag
  runtime_environment = var.runtime_environment
  cluster_id = var.cluster_ids.core_application
  namespace_id = var.namespace_id
  network = var.network
  allow_to_security_group_ids = []
}

module "apigw-authorizer" {
  source = "./16-apigw-authorizer"
  aws_provider = var.aws_provider
  name = "apigw-authorizer"
  image_tag = var.components["apigw-authorizer"].image_tag
  runtime_environment = var.runtime_environment
  network = var.network
  allow_to_security_group_ids = [
    module.authentication-api.security_group_id,
    module.profile-api.security_group_id
  ]
}

module "crypto-faucet" {
  count = var.runtime_environment == "develop" ? 1 : 0
  source = "./17-crypto-faucet"
  aws_provider = var.aws_provider
  name = "crypto-faucet"
  image_tag = var.components["crypto-faucet"].image_tag
  runtime_environment = var.runtime_environment
  network = var.network
  allow_to_security_group_ids = []
  datacache = var.datacache
  providers = {
    aws.dns = aws.dns
  }
}