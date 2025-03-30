include {
  path = find_in_parent_folders()
}

terraform {
  source = "${dirname(find_in_parent_folders())}/modules/network"
}

# Network module has no dependencies, just inherits from parent

