# Resource Blocks


# Create EC2 Instance
resource "aws_instance" "week-20" {
  ami             = var.ami_id
  instance_type   = var.instance_type
  subnet_id       = var.subnet_id
  key_name        = "Projectkey"
  user_data       = file("${path.module}/script.sh")
  security_groups = [aws_security_group.jenkins_sg.id]
  tags = {
    Name = "week-20"
  }
}

#Create security group  
resource "aws_security_group" "jenkins_sg" {
  name   = "jenkins_sg"
  vpc_id = var.vpc_id


  #Allow incoming on port 22 from my IP
  ingress {
    description = "Incoming SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["75.168.72.100/32"]
  }

  #Allow incoming TCP requests on port 8080 from any IP
  ingress {
    description = "Incoming 8080"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #Allow all outbound requests
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "week-20"
  }
}


# Create S3 Bucket
resource "aws_s3_bucket" "jenkins_artifacts" {
  bucket = random_id.randomness.hex

  tags = {
    Name = "week-20"
  }
}


#Create random number for S3 bucket name
resource "random_id" "randomness" {
  byte_length = 12
}