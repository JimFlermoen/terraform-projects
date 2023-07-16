# --Launch Template Resources--

data "aws_ami" "linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["al2023-ami-2023.1.20230705.0-kernel-6.1-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"]
}


# Create Launch Template Resource Block
resource "aws_launch_template" "web_tier_template" {
  name                   = "${var.name}-template"
  image_id               = data.aws_ami.linux.id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.asg_sg.id]
  user_data              = filebase64("script.sh")
  
  tags = {
    Name = "${var.name}-web_template"
  }
}

# Create ASG Resource Block
resource "aws_autoscaling_group" "web_asg" {
  name               = "${var.name}-asg"
  vpc_zone_identifier = tolist(var.public_subnets)
  desired_capacity   = 2
  max_size           = 3
  min_size           = 2


  launch_template {
    id      = aws_launch_template.web_tier_template.id
    version = aws_launch_template.web_tier_template.latest_version
  }
}

# Create Launch Template Resource Block
resource "aws_launch_template" "rds_template" {
  name                   = "${var.name}-template"
  image_id               = data.aws_ami.linux.id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.asg_sg.id]
  
  tags = {
    Name = "${var.name}-rds_template"
  }
}

# Create ASG Resource Block
resource "aws_autoscaling_group" "rds_asg" {
  name               = "${var.name}-asg"
  vpc_zone_identifier = aws_subnet.private_subnets["private_subnet_1"]
  desired_capacity   = 1
  max_size           = 2
  min_size           = 1


  launch_template {
    id      = aws_launch_template.rds_template_template.id
    version = aws_launch_template.rds_template_template.latest_version
  }
}

resource "aws_db_instance" "mysql" {
  allocated_storage    = 10
  max_allocated_storage = 
  db_subnet_group_name
  db_name              = "mydb"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  publicly_accessible    = false
  storage_encrypted
  username             = "foo"
  password             = "foobarbaz"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
}