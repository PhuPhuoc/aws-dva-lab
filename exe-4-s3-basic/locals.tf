locals {
  project_name = "exe-4-s3-basic"

  common_tags = {
    Project     = local.project_name
    Environment = "dev"
    ManagedBy   = "terraform"
    Author      = "PhuPhuoc"
  }

  aws_region = "us-east-1"
}
