data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "bastion_host" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.pub_sub_1.id

  vpc_security_group_ids = [
    aws_security_group.bastion_host_sg.id
  ]

  user_data = templatefile("scripts/init-ec2-bastion-host.sh", {
    private_key = tls_private_key.ec2_key.private_key_pem
  })

  tags = {
    Name = "d-ec2-SAA-vpc-bastion-host"
  }
}

resource "aws_ec2_instance_state" "bastion_host_state" {
  instance_id = aws_instance.bastion_host.id
  state       = var.instance_state
}

resource "aws_instance" "web_server" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.private_sub_1.id


  key_name = aws_key_pair.generated_key.key_name

  iam_instance_profile = aws_iam_instance_profile.web_server_profile.name

  vpc_security_group_ids = [
    aws_security_group.web_server_sg.id
  ]

  tags = {
    Name = "d-ec2-SAA-vpc-private-instance"
  }
}

resource "aws_ec2_instance_state" "web_server_state" {
  instance_id = aws_instance.web_server.id
  state       = var.instance_state
}
