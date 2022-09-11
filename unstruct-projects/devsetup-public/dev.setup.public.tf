# Create a VPC
resource "aws_vpc" "tagrant" {
  cidr_block           = "10.0.0.0/24"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Description = "tagrant VPC"
  }
}

resource "aws_subnet" "tagrant" {
  vpc_id                  = aws_vpc.tagrant.id
  cidr_block              = "10.0.0.0/25"
  map_public_ip_on_launch = true
  availability_zone       = "ap-south-1a"
  tags = {
    Description = "tagrant subnet"
  }
}

resource "aws_internet_gateway" "tagrant" {
  vpc_id = aws_vpc.tagrant.id

  tags = {
    Description = "tagrant internet gateway"
  }
}

resource "aws_route_table" "tagrant" {
  vpc_id = aws_vpc.tagrant.id

  tags = {
    Description = "tagrant route table"
  }
}

resource "aws_route" "tagrant" {
  route_table_id         = aws_route_table.tagrant.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.tagrant.id
}

resource "aws_route_table_association" "tagrant" {
  subnet_id      = aws_subnet.tagrant.id
  route_table_id = aws_route_table.tagrant.id
}

resource "aws_security_group" "tagrant" {
  name        = "tagrant_sg"
  description = "tagrant security group for dev"
  vpc_id      = aws_vpc.tagrant.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["115.187.43.124/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Description = "tagrant security group"
  }
}

resource "aws_key_pair" "tagrant" {
  key_name   = "tagrant"
  public_key = file("~/.ssh/tagrant.pub")
}

resource "aws_instance" "tagrant" {
  ami                    = data.aws_ami.tagrant.id
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.tagrant.id
  vpc_security_group_ids = [aws_security_group.tagrant.id]
  subnet_id              = aws_subnet.tagrant.id
  user_data              = file("userdata.tpl")

  root_block_device {
    volume_size = 10
  }

  # apply -replace
  provisioner "local-exec" {
    command = templatefile("${var.host_os}.ssh.config.tpl", {
      hostname     = self.public_ip,
      user         = "ubuntu",
      identityfile = "~/.ssh/tagrant"
      }
    )
    interpreter = var.host_os == "ubuntu" ? ["bash", "-c"] : ["Powershell", "-Command"]
  }

  tags = {
    Description = "tagrant compute"
  }
}
