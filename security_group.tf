#Create Security Group for Application Load Balancer, Only TCP/80,TCP/443 and Outbound Access
resource "aws_security_group" "alb-sg-master" {
  provider    = aws.region-master
  name        = "alb-master-sg"
  description = "Allow TCP/443 and TCP/80 traffic"
  vpc_id      = aws_vpc.vpc_master.id

  ingress {
    description = "Allow 443 from Everywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow 80 from Everywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "alb-master"
  }
}

#Create Security Group for Master Instance, Only TCP/8080 from ALB,TCP/22 from local ip
resource "aws_security_group" "instance-sg-master" {
  provider    = aws.region-master
  name        = "instance-master-sg"
  description = "Allow TCP/8080 and TCP/22"
  vpc_id      = aws_vpc.vpc_master.id

  ingress {
    description = "Allow 22 from IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.external_ip]
  }
  ingress {
    description     = "Allow 8080 from Application Load Balancer"
    from_port       = var.webserver-port
    to_port         = var.webserver-port
    protocol        = "tcp"
    security_groups = [aws_security_group.alb-sg-master.id]
  }
  ingress {
    description = "Allow traffic from us-west-2"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["192.168.1.0/24"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "instance-master-securitygroup"
  }
}

#Create Security Group for Master Instance, Only TCP/8080 from ALB,TCP/22 from local ip
resource "aws_security_group" "instance-sg-worker" {
  provider    = aws.region-worker
  name        = "instance-worker-sg"
  description = "Allow TCP/8080 and TCP/22"
  vpc_id      = aws_vpc.vpc_worker.id

  ingress {
    description = "Allow 22 from IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.external_ip]
  }
  ingress {
    description = "Allow traffic from us-east-1"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.1.0/24"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "instance-worker-securitygroup"
  }
}