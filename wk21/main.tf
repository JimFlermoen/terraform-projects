# AWS Region
provider "aws" {
  region = var.aws_region
}

# Create Launch Template Resource Block
resource "aws_launch_template" "asg_template" {
  name                   = var.name
  image_id               = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.asg_sg.id]
  user_data              = filebase64("script.sh")
  
  tags = {
    Name = var.name
  }
}

# Create ASG Resource Block
resource "aws_autoscaling_group" "asg" {
  name               = var.name
  availability_zones = var.availability_zones
  desired_capacity   = 2
  max_size           = 5
  min_size           = 2


  launch_template {
    id      = aws_launch_template.asg_template.id
    version = aws_launch_template.asg_template.latest_version
  }
}

# Create Security Group Block
resource "aws_security_group" "asg_sg" {
  name        = "asg_sg"
  description = "Allow web traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow port 80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow port 443"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.name
  }
}
# Create S3 Bucket
resource "aws_s3_bucket" "week-21" {
  bucket = var.bucket_name

  tags = {
    Name = var.name
  }
}

# Enable Versioning
resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.week-21.id
  versioning_configuration {
    status = "Enabled"
  }
}