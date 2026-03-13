terraform {
  backend "s3" {
    bucket         = "my-tfstate-dev"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "my-tfstate-lock"
    encrypt        = true
  }
}
