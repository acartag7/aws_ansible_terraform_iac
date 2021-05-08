#Get Linux AMI ID using SSM Parameter endpoint in us-east-1
data "aws_ssm_parameter" "linuxAmi-master" {
  provider = aws.region-master
  name     = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

#Get Linux AMI ID using SSM Parameter endpoint in us-west-1
data "aws_ssm_parameter" "linuxAmi-worker" {
  provider = aws.region-worker
  name     = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

#Create key-pair for logging into EC2 in us-east-1
resource "aws_key_pair" "master-instance-key" {
  provider   = aws.region-master
  key_name   = "cloud_key"
  public_key = file("~/.ssh/id_rsa.pub")
}

#Create key-pair for logging into EC2 in us-west-2
resource "aws_key_pair" "worker-instance-key" {
  provider   = aws.region-worker
  key_name   = "cloud_key"
  public_key = file("~/.ssh/id_rsa.pub")
}

#Create and Bootstrap ec2 in us-east-1
resource "aws_instance" "jenkins-master-instance" {
  provider = aws.region-master
  ami = data.aws_ssm_parameter.linuxAmi-master.value
  instance_type = "var.instance-type"
  key_name = aws_key_pair.master-instance-key.key_name
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.instance-sg-master.id]
  subnet_id = aws_subnet.subnet-1-master.id
  
  tags = {
    Name = "JenkinsMaster_TF"
  }

  depends_on = [aws_main_route_table_association.set-master-default-rt-assoc]
}

#Create and Bootstrap ec2 in us-west-2
resource "aws_instance" "jenkins-worker-instance" {
  provider = aws.region-worker
  count = var.workers-count
  ami = data.aws_ssm_parameter.linuxAmi-worker.value
  instance_type = "var.instance-type"
  key_name = aws_key_pair.worker-instance-key.key_name
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.instance-sg-worker.id]
  subnet_id = aws_subnet.subnet-1-worker.id
  
  tags = {
    Name = join("_", ["JenkinsWorker_TF", count.index +1])
  }

  depends_on = [aws_main_route_table_association.set-worker-default-rt-assoc, aws_instance.jenkins-master-instance]
}