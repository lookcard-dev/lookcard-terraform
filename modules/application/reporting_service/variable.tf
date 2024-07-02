variable "iam_role" {}

variable "default_listener" {}

variable "network" {
  type = object({
    vpc            = string
    private_subnet = list(string)
    public_subnet  = list(string)
  })
}
variable "cluster" {}

variable "env_secrets_arn" {}

variable "db_secret_secret_arn" {}

variable "token_secrets_arn" {}