variable "aws_provider" {
  type        = object({
    account_id = string
    region     = string
    profile    = string
  })
}

variable "domain" {
  type = object({
    general = string
    admin   = string
  })
  default = {
    general = "develop.not-lookcard.com"
    admin   = "develop.not-lookcard.com"
  }
}

variable "network" {
  type = object({
    cidr = object({
      vpc = string
      subnets = object({
        public   = list(string)
        private  = list(string)
        database = list(string)
        isolated = list(string)
      })
    })
    nat = object({
      provider = string
      count    = number
    })
  })
}

variable "runtime_environment" {
  type = string
  validation {
    condition     = contains(["develop", "testing", "staging", "production", "sandbox"], var.runtime_environment)
    error_message = "runtime_environment must be one of: develop, testing, staging, production, or sandbox"
  }
}

variable "image_tag" {
  type = object({
    card_api           = string
    user_api           = string
    profile_api        = string
    config_api         = string
    data_api           = string
    verification_api   = string
    authentication_api = string
    account_api        = string
    referral_api       = string
    notification_api   = string
    reseller_api       = string
    edns_api           = string
    enrollment_api     = string
    register_api       = string
    crypto_api         = string
    crypto_listener    = string
    crypto_processor   = string
    cronjob            = string
    reap_proxy         = string
    apigw_authorizer   = string
  })
}

# variable "secret" {

# }

locals {
  hostname = {
    public = {
      verification_portal = "verify"
      corporate_portal    = "portal.corporate"
      corporate_api       = "api.corporate"
      merchant_portal     = "portal.merchant"
      merchant_api        = "merchant_api"
      reseller_portal     = "portal.reseller"
      reseller_api        = "api.reseller"
      app_api             = "api"
      admin_api           = "api.admin"
      admin_console       = "console.admin"
      webhook             = "webhook"
      downloadable        = "download"
      enrollment_portal   = "enroll"
      enrollment_api      = "api.enroll"
      registration_portal = "register"
      registration_api    = "api.register"
      metadata            = "metadata"
      static              = "static"
    }

    internal = {
      card_api           = "card.api"
      profile_api        = "profile.api"
      data_api           = "data.api"
      notification_api   = "notification.api"
      user_api           = "user.api"
      config_api         = "config.api"
      account_api        = "account.api"
      authentication_api = "authentication.api"
      verification_api   = "verification.api"
      edns_api           = "edns.api"
      crypto_api         = "crypto.api"
      referral_api       = "referral.api"
      reseller_api       = "reseller.api"
      reap_proxy         = "reap.proxy"
      xray_daemon        = "xray.daemon"
      sumsub_webhook     = "sumsub.webhook"
      reap_webhook       = "reap.webhook"
    }
  }

  aws_provider = var.aws_provider

}