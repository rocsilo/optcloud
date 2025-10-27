provider "aws" {
    region = "us-east-1"
}

resource "aws_instance" "ec2_instance_1" {
  ami           = "ami-0c02fb55956c7d316"  # Amazon Linux 2023 en us-east-1
  instance_type = "t3.micro"
  
  tags = {
    Name = "ec2-instance-1"
  }
}

resource "aws_instance" "ec2_instance_2" {
  ami           = "ami-0c02fb55956c7d316"  # Amazon Linux 2023 en us-east-1
  instance_type = "t3.micro"
  
  tags = {
    Name = "ec2-instance-2"
  }
}


