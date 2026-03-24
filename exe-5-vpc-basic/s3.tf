resource "random_id" "suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "images" {
  bucket = "d-s3-exe-5-${random_id.suffix.hex}"

  tags = {
    Name = "images-bucket"
  }
}

resource "aws_s3_object" "images" {
  for_each = fileset("${path.module}/images", "*")

  bucket = aws_s3_bucket.images.id
  key    = "images/${each.value}"
  source = "images/${each.value}"
  etag   = filemd5("images/${each.value}")

  content_type = lookup({
    png  = "image/png"
    jpg  = "image/jpeg"
    jpeg = "image/jpeg"
  }, split(".", each.value)[1], "application/octet-stream")
}
