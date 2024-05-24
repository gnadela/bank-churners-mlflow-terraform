# IAM Role for EC2 Instance
resource "aws_iam_role" "mlflow_role" {
  name = "mlflow_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# IAM Policy for S3 Access
resource "aws_iam_policy" "mlflow_policy" {
  name        = "mlflow_policy"
  description = "IAM policy for MLflow to access S3"
  policy      = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "s3:ListBucket",
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ],
        Resource = [
          "arn:aws:s3:::g-mlflow-artifacts-bucket",
          "arn:aws:s3:::g-mlflow-artifacts-bucket/*"
        ]
      }
    ]
  })
}

# IAM Policy for RDS Access and IAM Database Authentication
resource "aws_iam_policy" "rds_access_policy" {
  name        = "mlflow_rds_access_policy"
  description = "IAM policy for MLflow to access RDS and IAM database authentication"
  policy      = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "rds:CreateDBInstance",
          "rds:DeleteDBInstance",
          "rds:DescribeDBInstances",
          "rds:ModifyDBInstance",
          "rds:RestoreDBInstanceFromDBSnapshot",
          "rds:RebootDBInstance",
          "rds-db:connect"
        ],
        Resource = "*"
      }
    ]
  })
}

# Attach Policy for S3 Access to Role
resource "aws_iam_role_policy_attachment" "mlflow_role_policy_attachment" {
  role       = aws_iam_role.mlflow_role.name
  policy_arn = aws_iam_policy.mlflow_policy.arn
}

# Attach Policy for RDS Access and IAM Database Authentication to Role
resource "aws_iam_role_policy_attachment" "rds_access_role_attachment" {
  role       = aws_iam_role.mlflow_role.name
  policy_arn = aws_iam_policy.rds_access_policy.arn
}

# IAM Instance Profile
resource "aws_iam_instance_profile" "mlflow_instance_profile" {
  name = "mlflow_instance_profile"
  role = aws_iam_role.mlflow_role.name
}
