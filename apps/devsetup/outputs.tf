####################################################
# TERRAFORM OUTPUTS
####################################################
output "instance-public_ip" {
  value       = module.ubuntu.instance-public_ip
  sensitive   = false
  description = "public IP output"
  depends_on  = []
}

output "instance-private_ip" {
  value       = module.ubuntu.instance-private_ip
  sensitive   = false
  description = "private IP output"
  depends_on  = []
}
