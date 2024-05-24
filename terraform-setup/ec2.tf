resource "aws_instance" "mlflow_server" {
  ami           = "ami-0ac67a26390dc374d" # Amazon Linux 2 AMI
  instance_type = "t2.micro"
  key_name      = "g-key"
  security_groups = [aws_security_group.mlflow_sg.name]

  user_data = templatefile("${path.module}/user_data.sh.tpl", {
    username = "gnadela",
    endpoint = "database-2.chk66w0awg4v.eu-west-1.rds.amazonaws.com",
    db_name  = "database-2",
    bucket   = "g-mlflow-bucket-new"
  })

  iam_instance_profile = aws_iam_instance_profile.mlflow_instance_profile.name

  tags = {
    Name = "MLflow Server"
  }
}
