resource "aws_vpc" "myvpc" {
  cidr_block       = "10.0.0.0/16"

  tags = {
    Name = "demo"
  }
}

resource "aws_subnet" "pubsub1" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "pubsub1"
  }
}

resource "aws_subnet" "pubsub2" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "pubsub2"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = "IGW"
  }
}

resource "aws_route_table" "RT" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "RT"
  }
}

resource "aws_route_table_association" "rta1" {
  subnet_id      = aws_subnet.pubsub1.id
  route_table_id = aws_route_table.RT.id
}

resource "aws_route_table_association" "rta2" {
  subnet_id      = aws_subnet.pubsub2.id
  route_table_id = aws_route_table.RT.id
}

resource "aws_security_group" "sg1" {
  name        = "SSH AND HTTP"
  description = "Allow HTTP and SSH traffic"
  vpc_id      = aws_vpc.myvpc.id

  tags = {
    Name = "sg1"
  }
}

resource "aws_vpc_security_group_ingress_rule" "HTTP" {
  security_group_id = aws_security_group.sg1.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "SSH" {
  security_group_id = aws_security_group.sg1.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "all_out" {
  security_group_id = aws_security_group.sg1.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_key_pair" "my_key" {
  key_name   = "my-key"
  public_key = file("~/.ssh/id_rsa.pub")   # Replace with your public key path
}

resource "aws_instance" "web1" {
  ami           = var.ami_id
  instance_type = var.instance_type_size
  subnet_id = aws_subnet.pubsub1.id
  key_name  = aws_key_pair.my_key.key_name
  vpc_security_group_ids = [aws_security_group.sg1.id]
  user_data =  <<-EOF
              #!/bin/bash
              apt update -y
              apt install -y apache2
              systemctl enable apache2
              systemctl start apache2
              echo "<h1>Hello from first EC2</h1>" > /var/www/html/index.html
              EOF


  tags = {
    Name = "webserver1"
  }
}

resource "aws_instance" "web2" {
  ami           = var.ami_id
  instance_type = var.instance_type_size
  subnet_id = aws_subnet.pubsub2.id
  key_name  = aws_key_pair.my_key.key_name
  vpc_security_group_ids = [aws_security_group.sg1.id]
  user_data = <<-EOF
              #!/bin/bash
              apt update -y
              apt install -y apache2
              systemctl enable apache2
              systemctl start apache2
              echo "<h1>Hello from second EC2</h1>" > /var/www/html/index.html
              EOF


  tags = {
    Name = "webserver2"
  }
}

