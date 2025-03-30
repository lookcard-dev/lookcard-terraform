#!/bin/bash

# Create environments directory if it doesn't exist
mkdir -p environments

# Loop through all terraform.*.tfvars.json files
for tfvars_file in terraform.*.tfvars.json; do
    # Extract environment name from file name
    env_name=${tfvars_file#terraform.}
    env_name=${env_name%.tfvars.json}
    
    echo "Generating environment for: $env_name"
    
    # Create environment directory
    mkdir -p "environments/$env_name"
    mkdir -p "environments/$env_name/modules/network"
    mkdir -p "environments/$env_name/modules/security"
    mkdir -p "environments/$env_name/modules/storage"
    mkdir -p "environments/$env_name/modules/compute"
    mkdir -p "environments/$env_name/modules/application"
    mkdir -p "environments/$env_name/modules/monitor"
    
    # Create environment terragrunt.hcl
    cat > "environments/$env_name/terragrunt.hcl" << EOF
include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../"
}

locals {
  # Load the image tags from the separate JSON file
  image_tags = jsondecode(file("\${get_parent_terragrunt_dir()}/image_tags/$env_name.json"))
}

inputs = {
EOF

    # Add all config except image_tag
    jq 'del(.image_tag)' "$tfvars_file" | \
    sed 's/^{$//' | \
    sed 's/^}$//' | \
    sed 's/^/  /' >> "environments/$env_name/terragrunt.hcl"
    
    # Add image_tag from the separate file
    echo "  # Load image tags from the external file" >> "environments/$env_name/terragrunt.hcl"
    echo "  image_tag = local.image_tags" >> "environments/$env_name/terragrunt.hcl"
    echo "}" >> "environments/$env_name/terragrunt.hcl"
    
    # Create module terragrunt.hcl files
    create_module_terragrunt() {
        local module=$1
        local source_path=$2
        
        cat > "environments/$env_name/modules/$module/terragrunt.hcl" << EOF
include {
  path = find_in_parent_folders()
}

terraform {
  source = "\${dirname(find_in_parent_folders())}/modules/$module"
}

EOF
        
        # Add dependencies if needed
        if [ "$module" = "security" ]; then
            cat >> "environments/$env_name/modules/$module/terragrunt.hcl" << EOF
dependency "network" {
  config_path = "../network"
  
  mock_outputs = {
    vpc_id = "mock-vpc-id"
    # Add other mock outputs as needed
  }
}
EOF
        elif [ "$module" = "storage" ]; then
            cat >> "environments/$env_name/modules/$module/terragrunt.hcl" << EOF
dependency "network" {
  config_path = "../network"
  
  mock_outputs = {
    vpc_id = "mock-vpc-id"
    database_subnet_ids = ["mock-subnet-1", "mock-subnet-2", "mock-subnet-3"]
  }
}

inputs = {
  vpc_id = dependency.network.outputs.vpc_id
  subnet_ids = {
    datacache = dependency.network.outputs.database_subnet_ids
    datastore = dependency.network.outputs.database_subnet_ids
  }
}
EOF
        elif [ "$module" = "compute" ]; then
            cat >> "environments/$env_name/modules/$module/terragrunt.hcl" << EOF
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
EOF
        elif [ "$module" = "application" ]; then
            # Application has many dependencies - a simplified version
            cat >> "environments/$env_name/modules/$module/terragrunt.hcl" << EOF
dependency "network" {
  config_path = "../network"
  mock_outputs = {
    vpc_id = "mock-vpc-id"
    private_subnet_ids = ["mock-subnet-1"]
    public_subnet_ids = ["mock-subnet-2"]
    isolated_subnet_ids = ["mock-subnet-3"]
    cloudmap_namespace_id = "mock-namespace"
    # Add other mock outputs
  }
}

dependency "compute" {
  config_path = "../compute"
  mock_outputs = {
    listener_cluster_id = "mock-cluster"
    composite_application_cluster_id = "mock-cluster"
    core_application_cluster_id = "mock-cluster"
    administrative_cluster_id = "mock-cluster"
    cronjob_cluster_id = "mock-cluster"
  }
}

dependency "storage" {
  config_path = "../storage"
  mock_outputs = {
    datastore_writer_endpoint = "mock-endpoint"
    datastore_reader_endpoint = "mock-endpoint"
    datacache_endpoint = "mock-endpoint"
  }
}

dependency "security" {
  config_path = "../security"
  mock_outputs = {
    data_generator_key_arn = "mock-arn"
    data_encryption_key_arn = "mock-arn"
    crypto_worker_alpha_key_arn = "mock-arn"
    crypto_liquidity_key_arn = "mock-arn"
  }
}

# Add inputs with dependencies
EOF
        fi
    }
    
    # Create module terragrunt files
    create_module_terragrunt "network" "./modules/network"
    create_module_terragrunt "security" "./modules/security"
    create_module_terragrunt "storage" "./modules/storage"
    create_module_terragrunt "compute" "./modules/compute"
    create_module_terragrunt "application" "./modules/application"
    create_module_terragrunt "monitor" "./modules/monitor"
    
    echo "Created terragrunt files for $env_name environment"
done

echo "Environment generation complete!" 