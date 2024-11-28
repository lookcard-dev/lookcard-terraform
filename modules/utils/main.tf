module "bastion" {
  source = "./bastion"
  network = var.network
}

module "monitor" {
  source = "./monitor"
  syn_canary_s3_bucket = var.syn_canary_s3_bucket
}