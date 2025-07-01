module "network" {
  source              = "./modules/network"
  network             = var.network
  aws_provider        = local.aws_provider.application
  runtime_environment = var.runtime_environment
  domain              = var.domain
  # Circular dependency resolved: ELB logging is disabled initially
  # After storage module creates the bucket, logging can be enabled manually in ELB module
}

module "security" {
  source              = "./modules/security"
  domain              = var.domain
  aws_provider        = local.aws_provider.application
  runtime_environment = var.runtime_environment
}

module "storage" {
  source              = "./modules/storage"
  aws_provider        = local.aws_provider.application
  runtime_environment = var.runtime_environment
  vpc_id              = module.network.vpc_id
  subnet_ids = {
    datacache = module.network.database_subnet_ids
    datastore = module.network.database_subnet_ids
  }
  components = local.components
  external_security_group_ids = {
    bastion_host = module.network.bastion_host_security_group_id
  }
  secret_arns = module.security.secret_arns
  depends_on  = [module.security, module.network]
}

module "compute" {
  source              = "./modules/compute"
  aws_provider        = local.aws_provider.application
  runtime_environment = var.runtime_environment
  vpc_id              = module.network.vpc_id
  subnet_ids          = module.network.private_subnet_ids
  depends_on          = [module.network]
}

module "application" {
  source              = "./modules/application"
  aws_provider        = local.aws_provider.application
  runtime_environment = var.runtime_environment
  depends_on          = [module.network, module.storage, module.compute, module.security]

  network = {
    vpc_id              = module.network.vpc_id
    private_subnet_ids  = module.network.private_subnet_ids
    public_subnet_ids   = module.network.public_subnet_ids
    isolated_subnet_ids = module.network.isolated_subnet_ids
  }

  cluster_ids = {
    listener              = module.compute.listener_cluster_id
    composite_application = module.compute.composite_application_cluster_id
    core_application      = module.compute.core_application_cluster_id
    administrative        = module.compute.administrative_cluster_id
    cronjob               = module.compute.cronjob_cluster_id
  }

  namespace_id = module.network.cloudmap_namespace_id

  datastore = {
    writer_endpoint = module.storage.datastore_writer_endpoint
    reader_endpoint = module.storage.datastore_reader_endpoint
  }

  datacache = {
    endpoint = module.storage.datacache_endpoint
  }

  components = local.components

  kms_key_arns = {
    data = {
      generator  = module.security.data_generator_key_arn
      encryption = module.security.data_encryption_key_arn
    }
    crypto = {
      worker = {
        alpha = module.security.crypto_worker_alpha_key_arn
      }
      liquidity = module.security.crypto_liquidity_key_arn
    }

    depends_on = [module.network, module.security]
  }

  domain = var.domain

  elb = {
    application_load_balancer_arn = module.network.application_load_balancer_arn
    network_load_balancer_arn     = module.network.network_load_balancer_arn

    application_load_balancer_dns_name = module.network.application_load_balancer_dns_name
    network_load_balancer_dns_name     = module.network.network_load_balancer_dns_name

    application_load_balancer_arn_suffix = module.network.application_load_balancer_arn_suffix
    network_load_balancer_arn_suffix     = module.network.network_load_balancer_arn_suffix

    application_load_balancer_http_listener_arn = module.network.application_load_balancer_http_listener_arn

  }

  api_gateway = {
    vpc_link_arn = module.network.api_gateway_vpc_link_arn
    vpc_link_id  = module.network.api_gateway_vpc_link_id
  }

  secret_arns = module.security.secret_arns

  external_security_group_ids = {
    datastore = {
      cluster = module.storage.datastore_cluster_security_group_id
      proxy   = module.storage.datastore_proxy_security_group_id
    }
    datacache    = module.storage.datacache_security_group_id
    bastion_host = module.network.bastion_host_security_group_id
    alb          = module.network.application_load_balancer_security_group_id
    ecs_cluster  = module.compute.listener_security_group_id
  }

  s3_bucket = {
    arns = {
      log  = module.storage.log_bucket_arn
      data = module.storage.data_bucket_arn
    }
    names = {
      log  = module.storage.log_bucket_name
      data = module.storage.data_bucket_name
    }
  }

  repository_urls = module.storage.ecr_repository_urls

  providers = {
    aws.us_east_1 = aws.us_east_1
    cloudflare    = cloudflare
  }
}

module "monitor" {
  source = "./modules/monitor"

  aws_provider        = local.aws_provider.application
  runtime_environment = var.runtime_environment
}
