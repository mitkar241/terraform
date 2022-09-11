####################################################
# VPC
####################################################
resource "aws_vpc" "tagrant" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Description = "tagrant VPC"
  }
}

####################################################
# SUBNET
####################################################
resource "aws_subnet" "tagrant" {
  count                   = length(var.subnet_ids)
  vpc_id                  = aws_vpc.tagrant.id
  cidr_block              = var.subnet_ids[count.index]
  availability_zone       = var.aws_availability_zone[count.index] #"${data.aws_availability_zones.available.names[count.index]}"
  map_public_ip_on_launch = true                                   #false
  tags = {
    Description = "tagrant subnet"
  }
}

####################################################
# INTERNET GATEWAY
####################################################
resource "aws_internet_gateway" "tagrant" {
  vpc_id = aws_vpc.tagrant.id
  tags = {
    Description = "tagrant internet gateway"
  }
}

####################################################
# ROUTE TABLE
####################################################
resource "aws_route_table" "tagrant" {
  vpc_id = aws_vpc.tagrant.id
  tags = {
    Description = "tagrant route table"
  }
}

####################################################
# ROUTE
####################################################
resource "aws_route" "tagrant" {
  route_table_id         = aws_route_table.tagrant.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.tagrant.id
}

####################################################
# ROUTE TABLE ASSOCIATION
####################################################
resource "aws_route_table_association" "tagrant" {
  count          = length(aws_subnet.tagrant.*.id)
  subnet_id      = aws_subnet.tagrant[count.index].id
  route_table_id = aws_route_table.tagrant.id
}

####################################################
# SECURITY GROUP
####################################################
resource "aws_security_group" "tagrant" {
  name   = "${var.tag_name}-sg"
  vpc_id = aws_vpc.tagrant.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
    description = "internal ingress HTTPS rule"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
    description = "internal ingress HTTP rule"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
    description = "internal ingress SSH rule"
  }

  ingress {
    from_port   = 53
    to_port     = 53
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
    description = "internal ingress DNS rule"
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["10.0.0.0/8"]
    description = "internal ingress ICMP rule"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0", ]
    description = "external ingress HTTP rule"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0", ]
    description = "external ingress HTTPS rule"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["104.114.76.145/32", "104.114.76.195/32", ]
    description = "deb.nodesource.com ingress HTTPS rule"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.host_public_ip}/32"]
    description = "external current IP ingress SSH rule"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/8"]
    description = "internal egress rule"
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["104.114.76.145/32", "104.114.76.195/32", ]
    description = "deb.nodesource.com egress HTTPS rule"
  }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0", ]
    description = "external egress HTTP rule"
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0", ]
    description = "external egress HTTPS rule"
  }

  tags = {
    Description = "tagrant security group"
  }
}

####################################################
# KEY PAIR
####################################################
resource "aws_key_pair" "tagrant" {
  key_name   = "tagrant"
  public_key = file("${var.ssh_public_key}")
}

####################################################
# EC2 INSTANCE Creation
####################################################
# Network interfaces(eni / nic) are created between subnet ID and VPC ID
module "ubuntu" {
  source        = "../../modules/compute/ec2/ubuntu"
  aws_ami_id    = data.aws_ami.tagrant.id
  instance_type = var.instance_type
  key_name      = aws_key_pair.tagrant.id
  volume_type   = var.volume_type
  volume_size   = var.volume_size
  subnet_ids    = aws_subnet.tagrant.*.id

  project_name           = "tagrant"
  environment            = "stag"
  instance_count         = 2
  instances_per_subnet   = 1
  vpc_security_group_ids = [aws_security_group.tagrant.id]
}

/*
####################################################
# Target Group Creation
####################################################
resource "aws_lb_target_group" "tagrant" {
  name        = "${var.tag_name}-tg"
  port        = 80
  target_type = "instance"
  protocol    = "HTTP"
  vpc_id      = aws_vpc.tagrant.id
  health_check {
    path                = "/health"
    interval            = 120
    timeout             = 30
    unhealthy_threshold = 3
    # above settings will do health checks every 120 seconds, will give 30 seconds for response to come and wait 3 attempts before declaring the instance dead
  }
}

####################################################
# Target Group Attachment with Instance: provisioning takes 3m30s+
####################################################
resource "aws_lb_target_group_attachment" "tagrant" {
  target_group_arn = aws_lb_target_group.tagrant.arn
  target_id        = aws_instance.tagrant.id
}

####################################################
# Application Load balancer
####################################################
resource "aws_lb" "tagrant" {
  name               = "${var.tag_name}-alb"
  internal           = true
  ip_address_type    = "ipv4"
  idle_timeout       = 600 # seconds. default is 60. Better to keep it high
  load_balancer_type = "application"
  security_groups    = [aws_security_group.tagrant.id]
  subnets = [
    aws_subnet.tagrant[0].id,
    aws_subnet.tagrant[1].id,
  ]
  tags = {
    Description = "tagrant application loadbalancer"
  }
}

####################################################
# Forward all HTTP traffic from the ALB to the target group
####################################################
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.tagrant.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    target_group_arn = aws_lb_target_group.tagrant.arn
    type             = "forward"
  }
}

/*
####################################################
# Forward all HTTPS traffic from the ALB to the target group
####################################################

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.tagrant.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = var.ssl_policy
  certificate_arn   = var.certificate_arn[var.aws_env]["arn"]

  default_action {
    target_group_arn = aws_lb_target_group.tagrant.arn
    type             = "forward"
  }
}

####################################################
# Redirecting HTTP traffic to HTTPS
####################################################
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.tagrant.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}
*/
