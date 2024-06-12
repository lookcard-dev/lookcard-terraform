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


