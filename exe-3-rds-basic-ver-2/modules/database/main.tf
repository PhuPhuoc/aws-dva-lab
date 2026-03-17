resource "aws_db_instance" "mysql" {
  identifier = "d-rds-dva-mysql"
  # Engine
  engine         = "mysql"
  engine_version = "8.0"
  # instance
  instance_class = "db.t3.micro"
  # Storage
  allocated_storage = 20
  storage_type      = "gp2"
  # Database settings
  db_name  = "mydb"
  username = "admin"
  password = "admin123"
  # Networking
  db_subnet_group_name   = var.db_subnet_name
  vpc_security_group_ids = [var.rds_sg_id]
  publicly_accessible    = true
  availability_zone      = "us-east-1a"
  # Database authentication
  iam_database_authentication_enabled = false
  # Single AZ
  multi_az = false
  # Skip snapshot when destroying
  skip_final_snapshot = true
}

