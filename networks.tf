#Create VPC in us-east-1
resource "aws_vpc" "vpc_master" {
  provider             = aws.region-master
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "master-vpc-jenkins"
  }
}

#Create VPC in us-west-1
resource "aws_vpc" "vpc_worker" {
  provider             = aws.region-worker
  cidr_block           = "192.168.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "worker-vpc-jenkins"
  }
}

#Create IGW in us-east-1
resource "aws_internet_gateway" "igw_master_vpc" {
  provider = aws.region-master
  vpc_id   = aws_vpc.vpc_master.id
}

#Create IGW in us-west-1
resource "aws_internet_gateway" "igw_worker_vpc" {
  provider = aws.region-worker
  vpc_id   = aws_vpc.vpc_worker.id
}

#Get all AZ in VPC for Master Region
data "aws_availability_zones" "azs_master" {
  provider = aws.region-master
  state    = "available"
}

#Create subnet #1 in us-east-1
resource "aws_subnet" "subnet-1-master" {
  provider          = aws.region-master
  availability_zone = element(data.aws_availability_zones.azs_master.names, 0)
  vpc_id            = aws_vpc.vpc_master.id
  cidr_block        = "10.0.1.0/24"
}

#Create subnet #1 in us-east-1
resource "aws_subnet" "subnet-2-master" {
  provider          = aws.region-master
  availability_zone = element(data.aws_availability_zones.azs_master.names, 1)
  vpc_id            = aws_vpc.vpc_master.id
  cidr_block        = "10.0.2.0/24"
}

#Get all AZ in VPC for Worker Region
data "aws_availability_zones" "azs_worker" {
  provider = aws.region-worker
  state    = "available"
}

#Create subnet #1 in us-west-1
resource "aws_subnet" "subnet-1-worker" {
  provider          = aws.region-worker
  availability_zone = element(data.aws_availability_zones.azs_worker.names, 0)
  vpc_id            = aws_vpc.vpc_worker.id
  cidr_block        = "192.168.1.0/24"
}

#Initiate Peering connection request from us-east-1
resource "aws_vpc_peering_connection" "useast1-uswest2" {
  provider = aws.region-master
  peer_vpc_id = aws_vpc.vpc_worker.id
  vpc_id = aws_vpc.vpc_master.id
  peer_region = var.region-worker
}

#Accept VPC peering request in us-west-2 from us-east-1
resource "aws_vpc_peering_connection_accepter" "accept-peering-vpc_master" {
  provider = aws.region-worker
  vpc_peering_connection_id = aws_vpc_peering_connection.useast1-uswest2.id
  auto_accept = true
}


#Create route table in us-east-1
resource "aws_route_table" "internet_route_vpc-master" {
  provider = aws.region-master
  vpc_id = aws_vpc.vpc_master.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_master_vpc.id
  }
  lifecycle {
    ignore_changes = all
  }
  tags = {
    Name = "Master-Region-RT"
  }
}

#Create route table in us-west-1
resource "aws_route_table" "internet_route_vpc-worker" {
  provider = aws.region-worker
  vpc_id = aws_vpc.vpc_worker.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_worker_vpc.id
  }
  route = [ {
    cidr_block = "192.168.0.0/16"
    vpc_peering_connection_id = aws_vpc_peering_connection.useast1-uswest2.id
  } ]  
  route = [ {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_master_vpc.id
  } ]
  lifecycle {
    ignore_changes = all
  }
  tags = {
    Name = "Worker-Region-RT"
  }
}

