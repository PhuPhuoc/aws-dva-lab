variable "alb_name" {
  description = "ALB name"
  type        = string
  default     = "d-lb-DVA-web-alb"
}
variable "tg_name" {
  description = "Target group name"
  type        = string
  default     = "d-tg-DVA-web-server"
}
variable "vpc_id" {
  description = "VPC ID"
  type        = string
}
variable "subnet_ids" {
  description = "List of subnet IDs"
  type        = list(string)
}
variable "alb_sg_id" {
  description = "ALB security group ID"
  type        = string
}
variable "ec2_instance_ids" {
  description = "Web EC2 instance IDs"
  type        = list(string)
}
variable "tags" {
  description = "Tags cho resource"
  type        = map(string)
}
