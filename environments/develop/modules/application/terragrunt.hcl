include {
  path = find_in_parent_folders()
}

terraform {
  source = "${dirname(find_in_parent_folders())}/modules/application"
}

dependency "network" {
  config_path = "../network"
  
  mock_outputs = {
    vpc_id = "mock-vpc-id"
    private_subnet_ids = ["mock-subnet-1"]
    public_subnet_ids = ["mock-subnet-2"]
    isolated_subnet_ids = ["mock-subnet-3"]
    cloudmap_namespace_id = "mock-namespace-id"
    application_load_balancer_arn = "mock-alb-arn"
    network_load_balancer_arn = "mock-nlb-arn"
    application_load_balancer_dns_name = "mock-alb-dns"
    network_load_balancer_dns_name = "mock-nlb-dns"
    application_load_balancer_http_listener_arn = "mock-listener-arn"
    api_gateway_vpc_link_arn = "mock-vpn-link-arn"
    api_gateway_vpc_link_id = "mock-vpn-link-id"
  }
}

dependency "compute" {
  config_path = "../compute"
  
  mock_outputs = {
    listener_cluster_id = "mock-listener-cluster"
    composite_application_cluster_id = "mock-composite-cluster"
    core_application_cluster_id = "mock-core-cluster"
    administrative_cluster_id = "mock-admin-cluster"
    cronjob_cluster_id = "mock-cronjob-cluster"
  }
}

dependency "storage" {
  config_path = "../storage"
  
  mock_outputs = {
    datastore_writer_endpoint = "mock-writer-endpoint"
    datastore_reader_endpoint = "mock-reader-endpoint"
    datacache_endpoint = "mock-cache-endpoint"
  }
}

dependency "security" {
  config_path = "../security"
  
  mock_outputs = {
    data_generator_key_arn = "mock-generator-key"
    data_encryption_key_arn = "mock-encryption-key"
    crypto_worker_alpha_key_arn = "mock-worker-key"
    crypto_liquidity_key_arn = "mock-liquidity-key"
  }
}

inputs = {
  # Network configuration
  network = {
    vpc_id = dependency.network.outputs.vpc_id
    private_subnet_ids = dependency.network.outputs.private_subnet_ids
    public_subnet_ids = dependency.network.outputs.public_subnet_ids
    isolated_subnet_ids = dependency.network.outputs.isolated_subnet_ids
  }
  
  # Cluster IDs
  cluster_ids = {
    listener = dependency.compute.outputs.listener_cluster_id
    composite_application = dependency.compute.outputs.composite_application_cluster_id
    core_application = dependency.compute.outputs.core_application_cluster_id
    administrative = dependency.compute.outputs.administrative_cluster_id
    cronjob = dependency.compute.outputs.cronjob_cluster_id
  }
  
  # CloudMap namespace
  namespace_id = dependency.network.outputs.cloudmap_namespace_id
  
  # Database connections
  datastore = {
    writer_endpoint = dependency.storage.outputs.datastore_writer_endpoint
    reader_endpoint = dependency.storage.outputs.datastore_reader_endpoint
  }
  
  # Redis cache
  datacache = {
    endpoint = dependency.storage.outputs.datacache_endpoint
  }
  
  # Components (inherited from parent)
  components = get_terraform_remote_state_outputs("components", {})
  
  # KMS keys
  kms_key_arns = {
    data = {
      generator = dependency.security.outputs.data_generator_key_arn
      encryption = dependency.security.outputs.data_encryption_key_arn
    }
    crypto = {
      worker = {
        alpha = dependency.security.outputs.crypto_worker_alpha_key_arn
      }
      liquidity = dependency.security.outputs.crypto_liquidity_key_arn
    }
  }
  
  # Domain config (inherited from parent)
  domain = get_terraform_remote_state_outputs("domain", {})
  
  # ELB configuration
  elb = {
    application_load_balancer_arn = dependency.network.outputs.application_load_balancer_arn
    network_load_balancer_arn = dependency.network.outputs.network_load_balancer_arn
    application_load_balancer_dns_name = dependency.network.outputs.application_load_balancer_dns_name
    network_load_balancer_dns_name = dependency.network.outputs.network_load_balancer_dns_name
    application_load_balancer_http_listener_arn = dependency.network.outputs.application_load_balancer_http_listener_arn
  }
  
  # API Gateway
  api_gateway = {
    vpc_link_arn = dependency.network.outputs.api_gateway_vpc_link_arn
    vpc_link_id = dependency.network.outputs.api_gateway_vpc_link_id
  }
  
  # Providers
  providers = {
    aws.dns = aws.dns
    aws.us_east_1 = aws.us_east_1
  }
}
