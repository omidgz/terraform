# Step 1: Define the provider
provider "aws" {
  region = "us-east-1" # Set your preferred region
}

# Step 2: Define the resource (EC2 instance)
resource "aws_instance" "example" {
  ami           = "ami-0182f373e66f89c85" # Amazon Linux 2 AMI ID (You can use the latest AMI for your region)
  instance_type = "t2.micro"              # Free-tier eligible instance

  # Step 3: Add security group to allow SSH access
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  tags = {
    Name = "Terraform-EC2"
  }
}

# Step 4: Define a security group to allow SSH access
resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow SSH from anywhere (use cautiously)
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Allow all outbound traffic
  }
}

# Step 5: Output the public IP of the EC2 instance
output "instance_public_ip" {
  value = aws_instance.example.public_ip
}
