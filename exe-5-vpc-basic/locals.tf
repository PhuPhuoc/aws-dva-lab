locals {
  project_name = "aws-dva-exe-5-vpc-basic"

  common_tags = {
    Project     = local.project_name
    Environment = "dev"
    ManagedBy   = "terraform"
    Author      = "Phu Phuoc"
  }

  public_subnets = {
    sub1 = aws_subnet.pub_sub_1.id
    sub2 = aws_subnet.pub_sub_2.id
  }

  web_servers = ["bastion-host-server", "private-web-server-1"]
}
