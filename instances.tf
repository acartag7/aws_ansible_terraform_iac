#Get Linux AMI ID using SSM Parameter endpoint in us-east-1
data "aws_ssm_parameter" "linuxAmi-master" {
    provider = aws.region-master
    name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

#Get Linux AMI ID using SSM Parameter endpoint in us-west-1
data "aws_ssm_parameter" "linuxAmi-worker" {
    provider = aws.region-worker
    name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2" 
}