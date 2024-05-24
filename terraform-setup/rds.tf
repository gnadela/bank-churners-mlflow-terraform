# RDS Instance for MLflow Backend Store
resource "aws_db_instance" "mlflow_db" {
  allocated_storage             = 20
  storage_type                  = "gp2"
  engine                        = "postgres"
  engine_version                = "16.2"
  instance_class                = "db.t3.micro"
  username                      = "postgres"
  password                      = "****"
  parameter_group_name          = "default.postgres16"
  skip_final_snapshot           = true
  iam_database_authentication_enabled = true  # Enable IAM database authentication

  # Add IAM Role Authentication
  tags = {
    Name = "MLflow RDS Instance"
  }
}
