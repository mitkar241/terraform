/*
terraform output
*/
output "dev-ip" {
  value       = aws_instance.tagrant.public_ip
  sensitive   = false
  description = "dev public IP output"
  depends_on  = []
}
