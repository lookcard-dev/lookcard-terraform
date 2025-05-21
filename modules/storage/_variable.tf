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

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = object({
    datacache = list(string)
    datastore = list(string)
  })
}

variable "namespace_id" {
  type = string
}

variable "components" {
  type = map(object({
    name = string
    hostname = object({
      internal = string
      public   = optional(string)
    })
    image_tag = string
  }))
}

variable "external_security_group_ids" {
  type = object({
    bastion_host = string
  })
}

variable "secret_arns" {
  type = map(string)
}
