provider "aws" {
  region     = "us-east-1"
}

resource "aws_vpc" "default" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "main"
  }
}

resource "aws_subnet" "default" {
  vpc_id                  = aws_vpc.default.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
}
resource "aws_subnet" "default2" {
  vpc_id            = aws_vpc.default.id
  cidr_block        = "10.0.2.0/24"  # Ensure this CIDR block is different and non-overlapping
  availability_zone = "us-east-1b"  # Choose a different AZ
  map_public_ip_on_launch = true

  tags = {
    Name = "MySecondSubnet"
  }
}

resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.default.id
}

resource "aws_route_table" "default" {
  vpc_id = aws_vpc.default.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.default.id
  }
}

resource "aws_route_table_association" "default" {
  subnet_id      = aws_subnet.default.id
  route_table_id = aws_route_table.default.id
}

resource "aws_security_group" "allow_web" {
  name        = "allow_web_traffic"
  description = "Allow web inbound traffic"
  vpc_id      = aws_vpc.default.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
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

resource "aws_instance" "web" {
  ami           = "ami-0c02fb55956c7d316" # Amazon Linux 2 AMI
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.default.id
  # security_groups = [aws_security_group.allow_web.name]
  vpc_security_group_ids = [aws_security_group.allow_web.id]


  user_data = file("init-script.sh")

  tags = {
    Name = "PHPWebServer"
  }
}
resource "aws_db_subnet_group" "my_subnet_group" {
  name       = "my-db-subnet-group"
  subnet_ids = [aws_subnet.default.id, aws_subnet.default2.id]  # Include both subnet IDs


  tags = {
    Name = "My DB Subnet Group"
  }
}

resource "aws_db_instance" "default" {
   allocated_storage    = 10
  db_name              = "mydb"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  username             = "admin"
  password             = "yourpassword"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  publicly_accessible  = true
  db_subnet_group_name = aws_db_subnet_group.my_subnet_group.name



  vpc_security_group_ids = [aws_security_group.allow_web.id]

  tags = {
    Name = "MyDBInstance"
  }
}

