# variable "task_role" {}
# variable "task_execution_role" {}
# variable "aggregator_tron_sqs_url" {}
variable "vpc_id" {}

variable "network" {
  type = object({
    vpc            = string
    private_subnet = list(string)
    public_subnet  = list(string)
  })
}
variable "cluster" {}

