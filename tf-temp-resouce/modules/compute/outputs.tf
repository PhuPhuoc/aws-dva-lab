output "instance_ids" {
  value = [for i in aws_instance.web_server : i.id]
}
