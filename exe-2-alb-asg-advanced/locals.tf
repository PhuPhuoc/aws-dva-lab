locals {
  project_name = "aws-dva-exe-2-advanced"

  common_tags = {
    Project     = local.project_name
    Environment = "dev"
    ManagedBy   = "terraform"
    Author      = "Phu Phuoc"
  }

}
