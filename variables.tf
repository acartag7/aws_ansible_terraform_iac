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
  default = "35.177.170.10/32"
}

variable "workers-count" {
  type    = number
  default = 3
}

variable "masters-count" {
  type    = number
  default = 1
}

variable "instance-type" {
  type    = string
  default = "t3.micro"
}

variable "webserver-port" {
  type    = number
  default = 8080
}

variable "dns-name" {
  type    = string
  default = "cmcloudlab1834.info."
}
