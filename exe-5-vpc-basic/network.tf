resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "d-vpc-dva-001"
  }
}

resource "aws_subnet" "pub_sub_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "d-vpc-pub-sub-dva-1"
  }
}

resource "aws_subnet" "pub_sub_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "d-vpc-pub-sub-dva-2"
  }
}

resource "aws_subnet" "private_sub_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "d-vpc-private-sub-dva-1"
  }
}

resource "aws_subnet" "private_sub_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "d-vpc-private-sub-dva-2"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "d-vpc-igw-dva"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id


  tags = {
    Name = "d-vpc-rtb-public-dva"
  }
}

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public" {
  for_each = local.public_subnets

  subnet_id      = each.value
  route_table_id = aws_route_table.public.id
}


resource "aws_eip" "nat_1" {
  domain = "vpc"
}

resource "aws_eip" "nat_2" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat_a" {
  subnet_id     = aws_subnet.pub_sub_1.id
  allocation_id = aws_eip.nat_1.id

  depends_on = [aws_internet_gateway.igw]

  tags = {
    Name = "d-vpc-nat-a-dva"
  }
}

resource "aws_nat_gateway" "nat_b" {
  subnet_id     = aws_subnet.pub_sub_2.id
  allocation_id = aws_eip.nat_2.id

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table" "private_a" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "d-vpc-rtb-private-a-dva"
  }
}

resource "aws_route_table" "private_b" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "d-vpc-rtb-private-b-dva"
  }
}

resource "aws_route" "private_a_nat_a" {
  route_table_id         = aws_route_table.private_a.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_a.id
}

resource "aws_route" "private_b_nat_b" {
  route_table_id         = aws_route_table.private_b.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_b.id
}

resource "aws_route_table_association" "private_a" {
  subnet_id      = aws_subnet.private_sub_1.id
  route_table_id = aws_route_table.private_a.id
}

resource "aws_route_table_association" "private_b" {
  subnet_id      = aws_subnet.private_sub_2.id
  route_table_id = aws_route_table.private_b.id
}
