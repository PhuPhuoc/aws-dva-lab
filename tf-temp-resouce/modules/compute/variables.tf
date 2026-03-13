variable "web_servers" {
  description = "List of web server names"
  type        = list(string)
}
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}
variable "web_sg_id" {
  description = "Web security group ID"
  type        = string
}
variable "tags" {
  description = "Extra tags cho EC2"
  type        = map(string)
}
