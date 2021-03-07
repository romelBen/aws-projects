resource "aws_s3_bucket" "example" {
  bucket = "lets-learn-terraform"
  acl = "private"

  lifecycle_rule {
    id = "archive"
    enabled = true

    prefix = "log/"

    tags = {
      "rule" = "log"
      "autoclean" = "true"
    }

    transition {
      days = 30
      storage_class = "STANDARD_IA"
    }

    transition {
      days = 60
      storage_class = "GLACIER"
    }

    expiration {
      days = 90
    }
  }

  tags = {
      Name = "Romel I. Benavides"
      Environment = "Dev"
  }
  versioning { 
      enabled = true
  }
}