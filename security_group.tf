#Create Security Group for Application Load Balancer, Only TCP/80,TCP/443 and Outbound Access
resource "aws_security_group" "alb-sg-master-vpc" {
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