terraform {
  backend "s3" {
    bucket  = "exe-3-version-2-tf-state-571c1212"
    key     = "terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}
