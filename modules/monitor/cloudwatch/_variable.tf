variable "aws_provider" {
  type = object({
    region     = string
    account_id = string
  })
}


variable "runtime_environment" {
  description = "Environment (develop, testing, staging, production, sandbox)"
  type        = string
}

variable "services" {
  description = "List of service names to monitor"
  type        = list(string)
  default     = [
    "profile-api", 
    "data-api", 
    "config-api", 
    "user-api", 
    "account-api", 
    "crypto-api", 
    "crypto-listener", 
    "authentication-api", 
    "verification-api", 
    "notification-api", 
    "referral-api", 
    "domain-api", 
    "reseller-api"
  ]
}
