include {
  path = find_in_parent_folders()
}

terraform {
  source = "../modules/security"
}

# Define dependencies
dependency "network" {
  config_path = "../modules/network"
  
  # Configure mock outputs for plan operations
  mock_outputs = {
    # Add mock outputs needed for planning
  }
}

inputs = {
  # Module-specific inputs
  # Any other inputs specific to the security module
} 