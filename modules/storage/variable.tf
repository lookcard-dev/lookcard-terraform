variable "s3_bucket" {}
variable "environment" {}
variable "aws_provider" {}
variable "secret_manager" {}
variable "network" {
  type = object({
    vpc             = string
    private_subnet  = list(string)
    public_subnet   = list(string)
    database_subnet = list(string)
  })
}