provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "web_server_sg" {
  name        = "allow_all_ssh"
  description = "Security group for web servers"
  vpc_id      = "vpc-12345678"

  ingress {
    description = "Allow SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
