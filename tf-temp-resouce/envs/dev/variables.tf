variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "web_servers" {
  type    = list(string)
  default = ["web-server-1", "web-server-2"]
}
