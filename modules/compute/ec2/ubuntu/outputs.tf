####################################################
# TERRAFORM OUTPUTS
####################################################
output "instance-public_ip" {
  value       = aws_instance.tagrant.*.public_ip
  sensitive   = false
  description = "public IP output"
  depends_on  = []
}

output "instance-private_ip" {
  value       = aws_instance.tagrant.*.private_ip
  sensitive   = false
  description = "private IP output"
  depends_on  = []
}
