# S3 Bucket for MLflow Artifacts
resource "aws_s3_bucket" "mlflow_bucket" {
  bucket = "g-mlflow-bucket-new"
}

resource "aws_s3_bucket_lifecycle_configuration" "mlflow_bucket_lifecycle" {
  bucket = aws_s3_bucket.mlflow_bucket.id

  rule {
    id     = "keep-current"
    status = "Enabled"

    noncurrent_version_expiration {
      noncurrent_days = 90
    }
  }
}
