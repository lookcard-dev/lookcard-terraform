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

variable "name" {
  type = string
}

variable "network" {
  type = object({
    vpc_id            = string
    private_subnet_ids = list(string)
    public_subnet_ids  = list(string)
    isolated_subnet_ids = list(string)
  })
}

variable "allow_to_security_group_ids"{
  type = list(string)
}

variable "image_tag" {
  type = string
}

variable "secret_arns" {
  type = map(string)
}

variable "external_security_group_ids" {
  type = object({
    bastion_host = string
  })
}

variable "repository_urls"{
  type = map(string)
}

