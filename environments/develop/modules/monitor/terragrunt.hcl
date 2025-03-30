include {
  path = find_in_parent_folders()
}

terraform {
  source = "${dirname(find_in_parent_folders())}/modules/monitor"
}

# Monitor has minimal dependencies, inherits most values from parent

