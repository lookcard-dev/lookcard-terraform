module "vpc" {
  source = "./vpc"
  network = var.network
  network_config = var.network_config
}
