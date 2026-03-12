# Latest Amazon Linux AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp*"]
  }
}


# aws_instance.web_server["web-server-1"]
# aws_instance.web_server["web-server-2"]
resource "aws_instance" "web_server" {
  for_each = toset(local.web_servers)

  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type

  # key_name = aws_key_pair.generated_key.key_name

  vpc_security_group_ids = [
    aws_security_group.web_sg.id
  ]

  user_data = file("scripts/init-ec2-temp-${each.value}.sh")

  tags = {
    Name = "d-ec2-DVA-${each.value}"
  }
}

# aws_ec2_instance_state.web_server_state["web-server-1"]
# aws_ec2_instance_state.web_server_state["web-server-2"]
resource "aws_ec2_instance_state" "web_server_state" {
  for_each = aws_instance.web_server

  instance_id = each.value.id
  state       = var.instance_state
}
