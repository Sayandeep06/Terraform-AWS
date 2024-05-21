//1. Cloud architecture deployment with Terraform with elb, s3, rds,  route 53, sgs, ec2. Visualize and implement (mastering Terraform). Networking architecture with Terraform (VPC, Subnets, IG, RT, Sgs)
provider "aws"{
    region = "us-west-2"
}
resource "aws_s3_bucket" "my-bucket"{
    bucket = "sayanawsacc-bucket"
}
resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16"
}
resource "aws_subnet" "my-subnet"{
    vpc_id = aws_vpc.main.id
    cidr_block= "10.0.1.0/24"
    availability_zone = "us-west-2a"
}
resource "aws_security_group" "ec2_sg"{
    name = "aws_instance_sg"
    vpc_id = aws_vpc.main.id

    ingress{
        from_port = 0
        to_port = 0
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]        
    }
}
resource "aws_instance" "web-app"{
    ami = "ami-0cf2b4e024cdb6960"
    subnet_id = aws_subnet.my-subnet.id
    vpc_security_group_ids = [aws_security_group.ec2_sg.id]
    instance_type = "t2.micro"
    associate_public_ip_address = true
}
