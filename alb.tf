resource "aws_alb" "application-lb-master" {
  provider           = aws.region-master
  name               = "front-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb-sg-master.id]
  subnets            = [aws_subnet.subnet-1-master.id, aws_subnet.subnet-2-master.id]
  tags = {
    Name = "Front-End-LB"
  }
}

resource "aws_lb_target_group" "front-lb-master-tg" {
  provider    = aws.region-master
  name        = "front-lb-tg"
  port        = var.webserver-port
  target_type = "instance"
  vpc_id      = aws_vpc.vpc_master.id
  protocol    = "HTTP"
  health_check {
    enabled  = true
    interval = 10
    path     = "/"
    port     = var.webserver-port
    protocol = "HTTP"
    matcher  = "200-299"
  }
  tags = {
    Name = "FrontEnd-Target-Group"
  }
}

resource "aws_alb_listener" "front-lb-master-listener" {
  provider          = aws.region-master
  load_balancer_arn = aws_alb.application-lb-master.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.front-lb-master-tg.arn
  }
}

resource "aws_alb_target_group_attachment" "frontend-master-attach" {
  provider         = aws.region-master
  target_group_arn = aws_lb_target_group.front-lb-master-tg.arn
  target_id        = aws_instance.jenkins-master-instance.id
  port             = var.webserver-port
}
