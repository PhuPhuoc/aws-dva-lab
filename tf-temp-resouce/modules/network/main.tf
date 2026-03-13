# Module: network sử dụng default VPC (dễ mở rộng VPC riêng nếu production)

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}
