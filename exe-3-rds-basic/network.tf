# default vpc
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
  filter {
    name = "availability-zone"
    values = [
      "us-east-1a",
      "us-east-1b",
      "us-east-1c"
    ]
  }
}

resource "aws_db_subnet_group" "default" {
  name       = "db_subnet"
  subnet_ids = data.aws_subnets.default.ids

  tags = {
    Name = "db subnet group"
  }
}
