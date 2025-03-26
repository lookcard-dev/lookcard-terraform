variable "domain" {
  type = object({
    general = object({
      name = string
      zone_id = string
    })
    admin = object({
      name = string
      zone_id = string
    })
  })
}
variable "aws_provider" {
  type = object({
    region     = string
    account_id = string
  })
}

variable "runtime_environment" {
  type = string
  validation {
    condition     = contains(["develop", "testing", "staging", "production", "sandbox"], var.runtime_environment)
    error_message = "runtime_environment must be one of: develop, testing, staging, production, or sandbox"
  }
}
