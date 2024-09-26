variable "vpc_id" {
  type = string
}

variable "my_ip_with_cidr" {
  type        = string
  description = "Provide your ip address eg 68.82.96.187/32"
}

variable "public_key" {
  type = string
}

variable "instance_type" {
  type    = string
  default = "true"
}

variable "server_name" {
  type    = string
  default = "Apache Server"
}
