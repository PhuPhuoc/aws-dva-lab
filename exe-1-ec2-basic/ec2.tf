# Latest Amazon Linux AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "my_first_ec2" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type

  key_name = aws_key_pair.generated_key.key_name

  vpc_security_group_ids = [
    aws_security_group.web_sg.id
  ]

  user_data = file("init-ec2.sh")

  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  tags = {
    Name = "aws-dva-k16-exe-1"
  }
}

resource "aws_ec2_instance_state" "my_instance_state" {
  instance_id = aws_instance.my_first_ec2.id
  state       = var.instance_state
}
