variable "app_name" {
  type = string
}

variable "image_name" {
  type = string
}

variable "replicas" {
  type    = number
  default = 2
}

variable "namespace" {
  type    = string
  default = "default"
}

variable "container_port" {
  type    = number
  default = 8080
}
