resource "aws_ecr_repository" "website" {

  name = "student-website"
}


resource "aws_vpc" "main" {

  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "student-vpc"
  }
}

resource "aws_subnet" "public1" {

 vpc_id = aws_vpc.main.id

 cidr_block = "10.0.1.0/24"

 availability_zone = "us-east-1a"
}

resource "aws_subnet" "public2" {

 vpc_id = aws_vpc.main.id

 cidr_block = "10.0.2.0/24"

 availability_zone = "us-east-1b"
}

resource "aws_security_group" "web" {

 name = "web-sg"

 vpc_id = aws_vpc.main.id

 ingress {

   from_port = 80
   to_port = 80

   protocol = "tcp"

   cidr_blocks = ["0.0.0.0/0"]
 }

 egress {

   from_port = 0
   to_port = 0

   protocol = "-1"

   cidr_blocks = ["0.0.0.0/0"]
 }
}

resource "aws_lb" "website" {

 name = "student-alb"

 internal = false

 load_balancer_type = "application"

 security_groups = [
   aws_security_group.web.id
 ]

 subnets = [
   aws_subnet.public1.id,
   aws_subnet.public2.id
 ]
}


resource "aws_ecs_cluster" "main" {

 name = "student-cluster"
}

