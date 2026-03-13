variable "vpc_id" {
  description = "VPC ID"
  type        = string
}
variable "alb_sg_name" {
  description = "ALB security group name"
  type        = string
  default     = "d-sg-dva-alb"
}
variable "web_sg_name" {
  description = "Web security group name"
  type        = string
  default     = "d-sg-dva-web-server"
}
