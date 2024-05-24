# Output the Public IP of the EC2 Instance
output "mlflow_server_public_ip" {
  value = aws_instance.mlflow_server.public_ip
}
