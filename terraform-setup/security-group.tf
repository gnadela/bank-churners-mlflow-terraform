# Security Group for MLflow Server
resource "aws_security_group" "mlflow_sg" {
  name        = "mlflow_sg"
  description = "Security group for MLflow server"
  vpc_id      = "vpc-0c92bc4a3435257ec"

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
