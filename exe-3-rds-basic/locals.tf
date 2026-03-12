locals {
  project_name = "aws-dva-exe-3"

  common_tags = {
    Project     = local.project_name
    Environment = "dev"
    ManagedBy   = "terraform"
    Author      = "PhuPhuoc"
  }
}
