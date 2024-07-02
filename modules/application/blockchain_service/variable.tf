variable "iam_role" {}

variable "lookcardlocal_namespace_id" {}
variable "cluster" {}
variable "network" {
  type = object({
    vpc            = string
    private_subnet = list(string)
    public_subnet  = list(string)
  })
}
variable "default_listener" {}

variable "env_secrets_arn" {}

variable "db_secret_secret_arn" {}

variable "token_secrets_arn" {}