# output
output "vpc_id" {
  value = data.aws_vpc.default.id
}

output "db_subnet_name" {
  value = aws_db_subnet_group.default.name
}
