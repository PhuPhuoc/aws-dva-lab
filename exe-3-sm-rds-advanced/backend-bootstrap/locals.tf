locals {
  project_name = "aws-dva-config-backend"

  common_tags = {
    Project     = local.project_name
    Environment = "dev"
    ManagedBy   = "terraform"
    Author      = "PhuPhuoc"
  }
}
