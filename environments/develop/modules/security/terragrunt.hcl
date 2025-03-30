include {
  path = find_in_parent_folders()
}

terraform {
  source = "${dirname(find_in_parent_folders())}/modules/security"
}

dependency "network" {
  config_path = "../network"
  
  mock_outputs = {
    vpc_id = "mock-vpc-id"
  }
}

inputs = {
  # Explicit passing of values from network module
  domain = merge(
    get_terraform_remote_state_outputs("domain", {}),
    {}  # You can add overrides here
  )
  
  # Passing providers
  providers = {
    aws.dns = aws.dns
  }
}
