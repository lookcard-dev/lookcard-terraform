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