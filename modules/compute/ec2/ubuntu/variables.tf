variable "instance_user" {
  description = "Default user of EC2 instance"
  type        = string
  default     = "ubuntu"
}

variable instance_count {
  description = "Number of EC2 instances to deploy"
  type        = number
}

variable "instances_per_subnet" {
  description = "Number of EC2 instances to deploy in each private subnet"
  type        = number
}

variable instance_type {
  description = "Type of EC2 instance to use"
  type        = string
}

variable subnet_ids {
  description = "Subnet IDs for EC2 instances"
  type        = list(string)
}

variable vpc_security_group_ids {
  description = "Security group IDs for EC2 instances"
  type        = list(string)
}

variable project_name {
  description = "Name of the project"
  type        = string
}

variable environment {
  description = "Name of the environment"
  type        = string
}

variable aws_ami_id {
  description = "AMI ID"
  type        = string
}

variable volume_type {
  description = "EBS volume type"
  type        = string
}

variable volume_size {
  description = "EBS volume size"
  type        = number
}

variable key_name {
  description = "Key for EC2 instance"
  type        = string
}

####################################################
# SSH KEY PATH
####################################################
variable "ssh_private_key" {
  type        = string
  default     = "~/.ssh/tagrant"
  description = "ssh private key path"
}

variable "ssh_public_key" {
  type        = string
  default     = "~/.ssh/tagrant.pub"
  description = "ssh public key path"
}
