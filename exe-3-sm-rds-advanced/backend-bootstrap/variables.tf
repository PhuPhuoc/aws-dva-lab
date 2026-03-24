variable "bucket_prefix" {
  description = "Prefix for the S3 bucket name (must be globally unique)"
  type        = string
  default     = "tf-state-backend"

  # validation {
  #   condition     = var.db_port > 0 && var.db_port < 65536
  #   error_message = "Invalid port"
  # }
}

variable "aws_region" {
  description = "AWS region to create resources in"
  type        = string
  default     = "us-east-1"
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}
