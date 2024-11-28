module "bastion" {
  source = "./bastion"
  network = var.network
}

module "syn-canary" {
  source = "./monitor/syn-canary"
  syn_canary_s3_bucket = var.syn_canary_s3_bucket
}