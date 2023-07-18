# --Main.tf--

#Retrieve the list of AZs
data "aws_availability_zones" "available" {}

# --VPC-- 
resource "aws_vpc" "wk22_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true

  tags = {
    Name = "${var.name}-vpc_change"
  }
}

# --Private Subnets--
resource "aws_subnet" "private_subnets" {
  count             = 2
  vpc_id            = aws_vpc.wk22_vpc.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index)
  availability_zone = element(data.aws_availability_zones.available.names, count.index)

  tags = {
    Name = var.public_subnets[count.index]
  }
}
# --Public Subnets--
resource "aws_subnet" "public_subnets" {
  count                   = 2
  vpc_id                  = aws_vpc.wk22_vpc.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index + 100)
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = var.public_subnets[count.index]
  }
}

# --Private Route Table--
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.wk22_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }
  tags = {
    Name = "${var.name}-private-rt"
  }
}

# --Public Route Table--
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.wk22_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${var.name}-public_rt"
  }
}

# --Private route table associaction--
resource "aws_route_table_association" "private" {
  for_each       = { for idx, subnet in aws_subnet.private_subnets : idx => subnet }
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_rt.id
}

# --Public route table associaction--
resource "aws_route_table_association" "public" {
  for_each       = { for idx, subnet in aws_subnet.public_subnets : idx => subnet }
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public_rt.id
}

# --Create Internet Gateway--
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.wk22_vpc.id

  tags = {
    Name = "${var.name}-igw"
  }
}

# --Create Elastic IP--
resource "aws_eip" "wk22_eip" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.igw]
}

# --Create Nat Gateway--
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.wk22_eip.id
  subnet_id     = aws_subnet.public_subnets[0].id

  tags = {
    Name = "${var.name}-nat_gateway"
  }
}

# --Amazon Linux AMI--
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
resource "aws_launch_template" "asg_template" {
  name                   = var.name
  image_id               = data.aws_ami.linux.id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  user_data              = filebase64("script.sh")

  tags = {
    Name = "${var.name}-template"
  }
}

# Create ASG Resource Block
resource "aws_autoscaling_group" "asg" {
  name                = "${var.name}-asg"
  vpc_zone_identifier = [for subnet in aws_subnet.public_subnets : subnet.id]
  desired_capacity    = 2
  max_size            = 3
  min_size            = 2

  launch_template {
    id      = aws_launch_template.asg_template.id
    version = aws_launch_template.asg_template.latest_version
  }
}

# --Create Security Group Block--
resource "aws_security_group" "web_sg" {
  name        = "web_sg"
  description = "Allow web traffic"
  vpc_id      = aws_vpc.wk22_vpc.id

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
    Name = "${var.name}-web_sg"
  }
}

# --MYSQL-- 
resource "aws_db_instance" "mysql" {
  allocated_storage      = var.allocated_storage
  max_allocated_storage  = var.max_allocated_storage
  storage_type           = var.storage_type
  db_subnet_group_name   = aws_db_subnet_group.mysql_subnet_group.name
  db_name                = var.db_name
  engine                 = var.engine
  engine_version         = var.engine_version
  instance_class         = var.instance_class
  publicly_accessible    = var.publicly_accessible
  username               = var.username
  password               = var.passwd
  skip_final_snapshot    = var.skip_final_snapshot
  vpc_security_group_ids = [aws_security_group.mysql_sg.id]
  port                   = 3306
}

# --Create DB Subnet Group--
resource "aws_db_subnet_group" "mysql_subnet_group" {
  name       = "mysql_subnet_group"
  subnet_ids = [for subnet in aws_subnet.private_subnets : subnet.id]

  tags = {
    Name = "${var.name}-subnet_group"
  }
}

# --Create Security Group Block--
resource "aws_security_group" "mysql_sg" {
  name        = "mysql_sg"
  description = "mysql_sg"
  vpc_id      = aws_vpc.wk22_vpc.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.web_sg.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.name}-mysql_sg"
  }
}