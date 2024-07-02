variable "network" {
  type = object({
    vpc            = string
    private_subnet = list(string)
    public_subnet  = list(string)
  })
}

variable "default_listener" {}

variable "iam_role" {}
variable "cluster" {}
variable "sg_alb_id" {}
variable "vpc_id" {}

variable "lookcardlocal_namespace_id" {}
variable "env_secrets_arn" {}

variable "db_secret_secret_arn" {}

variable "token_secrets_arn" {}
