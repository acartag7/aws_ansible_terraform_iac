variable "profile" {
  type    = string
  default = "default"
}

variable "region-master" {
  type    = string
  default = "us-east-1"
}

variable "region-worker" {
  type    = string
  default = "us-west-2"
}

variable "external_ip" {
  type    = string
  default = "46.6.3.14/32"
}

variable "workers-count" {
  type    = number
  default = 2
}

variable "instance-type" {
  type    = string
  default = "t3.micro"
}