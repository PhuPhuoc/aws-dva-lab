resource "random_id" "suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "tf_state_backend" {
  bucket        = "${var.bucket_prefix}-${random_id.suffix.hex}"
  force_destroy = false

  tags = var.tags
}

resource "aws_s3_bucket_server_side_encryption_configuration" "tf_state_backend_encryption" {
  bucket = aws_s3_bucket.tf_state_backend.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_ownership_controls" "tf_state_backend_ownership" {
  bucket = aws_s3_bucket.tf_state_backend.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_versioning" "tf_state_backend_versioning" {
  bucket = aws_s3_bucket.tf_state_backend.id
  versioning_configuration {
    status = "Enabled"
  }
}


resource "aws_s3_bucket_public_access_block" "tf_state_backend" {
  bucket = aws_s3_bucket.tf_state_backend.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
