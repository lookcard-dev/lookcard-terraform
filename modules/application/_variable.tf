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

variable "cluster_id"{
  type = string
}

variable "namespace_id"{
  type = string
}

variable "network" {
  type = object({
    vpc            = string
    private_subnet_ids = list(string)
    public_subnet_ids  = list(string)
    isolated_subnet_ids = list(string)
  })
}

variable "datastore" {
  type = object({
    writer_endpoint = string
    reader_endpoint = string
  })
}

variable "datacache" {
  type = object({
    endpoint = string
  })
}

variable "components" {
  type = map(object({
    name = string
    hostname = object({
      internal = string
      public = optional(string)
    })
    image_tag = string
  }))
}