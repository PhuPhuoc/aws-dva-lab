# Latest Amazon Linux AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp*"]
  }
}

resource "aws_launch_template" "web_server" {
  name_prefix   = "web-template"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"

  vpc_security_group_ids = [
    aws_security_group.web_sg.id
  ]

  user_data = base64encode(file("scripts/init-ec2.sh"))

  tags = {
    Name = "d-asg-DVA-web-server"
  }
}
