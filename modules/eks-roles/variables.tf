variable "cluster_name" {}

variable "environment" {}

variable "tags" {
  type    = map(string)
  default = { "Name" = "" }
}

variable "allow_entities" {
  type = list
  default = ["admin", "qa", "developer"]
}

variable "entities" {
  type = map(any)
  default = {
    admin = {},
    developer = {},
    qa = {}
  }
}