# variable "vpc_id" {

# }
variable "network" {
  type = object({
    vpc            = string
    private_subnet = list(string)
    public_subnet  = list(string)
  })
}
variable "ecs_cluster_id" {

}
variable "private_subnet_list" {

}
variable "alb_arn" {

}
