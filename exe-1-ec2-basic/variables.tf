variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}


variable "instance_state" {
  description = "EC2 instance state"
  type        = string
}

variable "allowed_ssh_ip" {
  description = "IP allowed to SSH"
  type        = string
}
