variable "network" {
  type = object({
    vpc             = string
    private_subnet  = list(string)
    public_subnet   = list(string)
    database_subnet = list(string)
  })
}





