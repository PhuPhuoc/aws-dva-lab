data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp*"]
  }
}

resource "aws_instance" "web_server" {
  for_each               = toset(var.web_servers)
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [var.web_sg_id]
  user_data              = file("${path.module}/../../scripts/init-ec2.sh")
  tags = merge({
    Name = "d-ec2-DVA-${each.value}"
  }, var.tags)
}
