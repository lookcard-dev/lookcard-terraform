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

variable "vpc_id"{
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "allow_from_security_group_ids" {
  type = list(string)
  default = []
}

variable "external_security_group_ids" {
  type = object({
    bastion_host = string
  })
}

variable "secret_arns" {
  type = map(string)
}