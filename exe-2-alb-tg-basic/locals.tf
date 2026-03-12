locals {
  project_name = "aws-dva-exe-2"

  common_tags = {
    Project     = local.project_name
    Environment = "dev"
    ManagedBy   = "terraform"
    Author      = "Phu Phuoc"
  }

  web_servers = ["web-server-1", "web-server-2"]
}
