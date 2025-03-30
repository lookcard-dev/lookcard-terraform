include {
  path = find_in_parent_folders()
}

terraform {
  source = "${dirname(find_in_parent_folders())}/modules/compute"
}

dependency "network" {
  config_path = "../network"
  
  mock_outputs = {
    vpc_id = "mock-vpc-id"
    private_subnet_ids = ["mock-subnet-1", "mock-subnet-2", "mock-subnet-3"]
  }
}

inputs = {
  vpc_id = dependency.network.outputs.vpc_id
  subnet_ids = dependency.network.outputs.private_subnet_ids
}
