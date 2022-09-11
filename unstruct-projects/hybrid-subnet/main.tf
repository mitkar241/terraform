####################
# KEY PAIR ALGORITHM
####################
resource "tls_private_key" "private_key" {
  algorithm = "ED25519"
}

####################
# AWS KEY-PAIR
####################
resource "aws_key_pair" "key_pair" {
  depends_on = [tls_private_key.private_key]
  key_name   = var.key_name
  public_key = tls_private_key.private_key.public_key_openssh
}

####################
# SAVE PRIVATE KEY
####################
resource "local_file" "save_key" {
  depends_on = [aws_key_pair.key_pair]
  content    = tls_private_key.private_key.private_key_pem
  filename   = "${var.base_path}${var.key_name}.pem"
}

####################
# VPC
####################
resource "aws_vpc" "vpc" {
  cidr_block       = "192.168.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "hybrid-vpc"
  }

  enable_dns_hostnames = true
}

####################
# PUBLIC SUBNET
####################
resource "aws_subnet" "public_subnet" {
  depends_on = [
    aws_vpc.vpc,
  ]

  vpc_id     = aws_vpc.vpc.id
  cidr_block = "192.168.0.0/24"

  availability_zone_id = "aps1-az1"

  tags = {
    Name = "public-subnet"
  }

  map_public_ip_on_launch = true
}

####################
# PRIVATE SUBNET
####################
resource "aws_subnet" "private_subnet" {
  depends_on = [
    aws_vpc.vpc,
  ]

  vpc_id     = aws_vpc.vpc.id
  cidr_block = "192.168.1.0/24"

  availability_zone_id = "aps1-az3"

  tags = {
    Name = "private-subnet"
  }
}

####################
# INTERNET GATEWAY
####################
resource "aws_internet_gateway" "internet_gateway" {
  depends_on = [
    aws_vpc.vpc,
  ]

  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "internet-gateway"
  }
}

####################
# INTERNET GATEWAY ROUTE TABLE
####################
resource "aws_route_table" "igw_route_table" {
  depends_on = [
    aws_vpc.vpc,
    aws_internet_gateway.internet_gateway,
  ]

  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name = "igw-route-table"
  }
}

####################
# ASSOCIATE ROUTE TABLE TO PUBLIC SUBNET
####################
resource "aws_route_table_association" "associate_routetable_to_public_subnet" {
  depends_on = [
    aws_subnet.public_subnet,
    aws_route_table.igw_route_table,
  ]
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.igw_route_table.id
}

####################
# ELASTIC IP
####################
resource "aws_eip" "elastic_ip" {
  vpc = true
}

####################
# NAT GATEWAY
####################
resource "aws_nat_gateway" "nat_gateway" {
  depends_on = [
    aws_subnet.public_subnet,
    aws_eip.elastic_ip,
  ]
  allocation_id = aws_eip.elastic_ip.id
  subnet_id     = aws_subnet.public_subnet.id

  tags = {
    Name = "nat-gateway"
  }
}

####################
# ROUTE TABLE WITH TARGET AS NAT GATEWAY
####################
resource "aws_route_table" "nat_route_table" {
  depends_on = [
    aws_vpc.vpc,
    aws_nat_gateway.nat_gateway,
  ]

  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gateway.id
  }

  tags = {
    Name = "NAT-route-table"
  }
}

####################
# ASSOCIATE ROUTE TABLE TO PRIVATE SUBNET
####################
resource "aws_route_table_association" "associate_routetable_to_private_subnet" {
  depends_on = [
    aws_subnet.private_subnet,
    aws_route_table.nat_route_table,
  ]
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.nat_route_table.id
}

####################
# BASTION HOST SECURITY GROUP
####################
resource "aws_security_group" "sg_bastion_host" {
  depends_on = [
    aws_vpc.vpc,
  ]
  name        = "sg bastion host"
  description = "bastion host security group"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "allow SSH"
    from_port   = 22
    to_port     = 22
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

####################
# INTERNAL HOST SECURITY GROUP
####################
resource "aws_security_group" "sg_internal_host" {
  depends_on = [
    aws_vpc.vpc,
  ]
  name        = "sg internal host"
  description = "internal host security group"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "allow TCP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description     = "allow SSH"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.sg_bastion_host.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

####################
# BASTION INSTANCE
####################
resource "aws_instance" "bastion_host" {
  depends_on = [
    aws_security_group.sg_bastion_host,
  ]
  ami                    = "ami-0732b62d310b80e97"
  instance_type          = "t2.micro"
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.sg_bastion_host.id]
  subnet_id              = aws_subnet.public_subnet.id
  tags = {
    Name = "bastion host"
  }

  /*provisioner "file" {
    source      = "${var.base_path}${var.key_name}.pem"
    destination = "/home/ec2-user/${var.key_name}.pem"

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = tls_private_key.private_key.private_key_pem
      host        = aws_instance.bastion_host.public_ip
    }
  }*/
}

####################
# INTERNAL INSTANCE
####################
resource "aws_instance" "internal_host" {
  depends_on = [
    aws_security_group.sg_internal_host,
    aws_nat_gateway.nat_gateway,
    aws_route_table_association.associate_routetable_to_private_subnet,
  ]
  ami                    = "ami-0732b62d310b80e97"
  instance_type          = "t2.micro"
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.sg_internal_host.id]
  subnet_id              = aws_subnet.private_subnet.id
  tags = {
    Name = "internal host"
  }
}
