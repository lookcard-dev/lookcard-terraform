module "syn-canary" {
  source               = "./syn-canary"
  syn_canary_s3_bucket = var.syn_canary_s3_bucket
}

module "sns" {
  source                  = "./sns"
  sns_subscriptions_email = var.sns_subscriptions_email
}
