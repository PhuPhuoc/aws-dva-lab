resource "random_id" "suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "static_website" {
  bucket        = "${var.bucket_prefix}-${random_id.suffix.hex}"
  force_destroy = false
}

resource "aws_s3_bucket_website_configuration" "static_website_config" {
  bucket = aws_s3_bucket.static_website.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "404.html"
  }
}

resource "aws_s3_object" "files" {
  for_each = fileset("static", "*.html")

  bucket = aws_s3_bucket.static_website.id
  key    = each.value
  source = "static/${each.value}"

  content_type = "text/html"
}

resource "aws_s3_bucket_policy" "public" {
  bucket = aws_s3_bucket.static_website.id

  depends_on = [
    aws_s3_bucket_public_access_block.this
  ]

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = "*"
      Action    = ["s3:GetObject"]
      Resource  = "${aws_s3_bucket.static_website.arn}/*"
    }]
  })
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.static_website.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}
