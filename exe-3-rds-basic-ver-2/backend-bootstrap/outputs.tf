output "bucket_name" {
  description = "The name of the S3 bucket"
  value       = aws_s3_bucket.tf_state_backend.bucket
}

output "bucket_region" {
  description = "The AWS region where the bucket is located"
  value       = var.aws_region
}

output "bucket_arn" {
  description = "The ARN of the S3 bucket"
  value       = aws_s3_bucket.tf_state_backend.arn
}
