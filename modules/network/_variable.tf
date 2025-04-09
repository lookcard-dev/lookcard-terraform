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
  validation {
    condition     = contains(["instance", "gateway"], var.network.nat.provider)
    error_message = "NAT provider must be either 'instance' or 'gateway'."
  }
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