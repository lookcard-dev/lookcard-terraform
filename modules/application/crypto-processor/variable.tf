variable "network" {
  type = object({
    vpc            = string
    private_subnet = list(string)
  })
}

variable "image" {
  type = object({
    url = string
    tag = string
  })
}

variable "allow_to_security_group_ids"{
  type = object({
    sweep = list(string)
    withdrawal = list(string)
  })
}