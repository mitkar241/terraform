/*
AMI ID = ami-0851b76e8b1bce90b
AMI name = ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*
Owner account ID = 099720109477
*/

####################################################
# TERRAFORM DATASOURCES
####################################################
# Create an AMI that will start a machine whose root device is backed by
# an EBS volume populated from a snapshot. It is assumed that such a snapshot
# already exists with the id "snap-xxxxxxxx".
data "aws_ami" "tagrant" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}
