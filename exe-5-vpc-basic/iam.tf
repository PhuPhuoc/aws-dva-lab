# IAM Role for EC2
resource "aws_iam_role" "ec2_role" {
  name = "ec2-s3-admin-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRole"

        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# Attach S3 Admin Policy
resource "aws_iam_role_policy_attachment" "s3_admin" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

# Instance Profile
resource "aws_iam_instance_profile" "web_server_profile" {
  name = "ec2-s3-admin-profile"
  role = aws_iam_role.ec2_role.name
}
