include {
  path = find_in_parent_folders()
}

terraform {
  source = "../modules/network"
}

# Explicitly indicate provider dependencies
dependency "root" {
  config_path = "../root"
  
  # Configure mock outputs for plan operations
  mock_outputs = {
    # Add mock outputs if needed for planning
  }
}

inputs = {
  # Module-specific inputs
  # Any other inputs specific to the network module
} 