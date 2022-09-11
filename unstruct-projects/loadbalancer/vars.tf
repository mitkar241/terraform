####################################################
# BASIC CONFIGS
####################################################
variable "aws_env" {
  type        = string
  default     = "dev"
  description = "aws stripe where setup will be deployed"
}

variable "host_public_ip" {
  type        = string
  default     = "X.X.X.X"
  description = "public IP of current host"
}

####################################################
# .AWS CONFIG VARIABLES
####################################################
variable "aws_region" {
  type        = string
  default     = "ap-south-1"
  description = "aws region"
}

variable "aws_availability_zone" {
  type = list
  #default = ["ap-south-1a", "ap-south-1b", "ap-south-1c", "ap-south-1d"]
  default     = ["ap-south-1a", "ap-south-1b"]
  description = "value of availability zone list"
}

variable "iam_cred_path" {
  type        = string
  default     = "~/.aws/credentials"
  description = "iam credentials file path"
}

variable "iam_cred_profile" {
  type = map(any)
  default = {
    "dev"  = "tagrant"
    "prod" = "tagrant"
  }
  description = "iam credentials profile"
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

####################################################
# TAG VARIABLES
####################################################
variable "tag_environment" {
  type = map(any)
  default = {
    "dev"  = "dev"
    "prod" = "prod"
  }
  description = "value of tag: Environment"
}

variable "tag_name" {
  type        = string
  default     = "tagrant" #"tagtest"
  description = "value of tag: Name"
}

variable "tag_owner" {
  type        = string
  default     = "mitkar241"
  description = "value of tag: Owner"
}

####################################################
# VPC VARIABLES
####################################################
variable "vpc_cidr_block" {
  type        = string
  default     = "10.0.0.0/24"
  description = "value of vpc cidr block"
}

####################################################
# SUBNET VARIABLES
####################################################
variable "subnet_cidr_block" {
  type = list(any)
  #default = ["10.0.0.0/26", "10.0.0.64/26", "10.0.0.128/26", "10.0.0.192/26"]
  default     = ["10.0.0.0/26", "10.0.0.64/26"]
  description = "value of subnet cidr list"
}

####################################################
# EC2 VARIABLES
####################################################
variable "instance_type" {
  type        = string
  default     = "t2.micro"
  description = "instance type of ec2 instance"
}

variable "instance_user" {
  type        = string
  default     = "ubuntu"
  description = "instance user of ec2 instance"
}

####################################################
# EBS VOLUME VARIABLES
####################################################

variable "volume_type" {
  type        = string
  default     = "gp2"
  description = "ebs volume type"
}

variable "volume_size" {
  type        = number
  default     = 10
  description = "ebs volume size"
}

####################################################
# ACM VARIABLES
####################################################
variable "ssl_policy" {
  type        = string
  default     = "ELBSecurityPolicy-TLS-1-2-2017-01"
  description = "ssl_policy of acm certificate"
}
