include {
  path = find_in_parent_folders()
}

terraform {
  source = "${dirname(find_in_parent_folders())}/modules/storage"
}

dependency "network" {
  config_path = "../network"
  
  mock_outputs = {
    vpc_id = "mock-vpc-id"
    database_subnet_ids = ["mock-subnet-1", "mock-subnet-2", "mock-subnet-3"]
  }
}

dependency "security" {
  config_path = "../security"
  
  mock_outputs = {
    # Add any required security outputs
  }
}

inputs = {
  vpc_id = dependency.network.outputs.vpc_id
  subnet_ids = {
    datacache = dependency.network.outputs.database_subnet_ids
    datastore = dependency.network.outputs.database_subnet_ids
  }
  
  # Get components from parent
  components = get_terraform_remote_state_outputs("components", {})
}
