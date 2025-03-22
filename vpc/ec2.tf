resource "aws_instance" "web_instance" {
  ami             = var.image_id #"ami-04b4f1a9cf54c11d0" 
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.public_subnet.id
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.allow_http.id]
  key_name = aws_key_pair.deployer.key_name

tags = {
    Name = "WebServer"
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install -y apache2
              sudo systemctl start apache2
              echo "Hello, World" > /var/www/html/index.html
              EOF

}

resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow HTTP inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.web_vpc.id

  tags = {
    Name = "allow_http"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_ipv4" {
  security_group_id = aws_security_group.allow_http.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4" {
  security_group_id = aws_security_group.allow_http.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_http.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" 
}

resource "aws_key_pair" "deployer" {
  key_name   = "Nagham-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCm1edkg2WvTFRW53X/x0YhWovLLKS2XyQDDvSG2kT3STmd24t5qofjtzvjiF4ylVWvHEdhNy+8/k42XFUwWDXsGxqsYNjoVhLAA86ARp6NqZJEHsebtVrpZLhOFw7w5cv8oNIwmpqMTeyCnpH2X4aOQhhuZ9lZpAWNiSoGmU3N53yl5EEg9l0mfDhfapq+UClBDhdNNnqM72VbyppHf53wmDVUzq/IxrObffV+T0DS4mgMTQQrwOaan5J8PYMvmEZiavWiVQ667x4qxsTijEBtwWmrXOo1ALfzDXcWuzKsh6YODvDr4owyZi22p6ugzPrj7orlRLQBjN+o3Fj50xPv2i7rY0cEQ0JebrZZbfPOqitblxO67hnta+rATDayI1svzSJLCayJtzrRbsxxhSmW9JRveRHwCWzSLpUsn3L258X9HAY3f4tk+6c3ATgxiP/uir+nYlRykNZ1C6ilaWEVX+yWitthMvU3zRaQ2vBjWzCPKuUUvXpRgsgZxcu+0nE= agent@agent-VirtualBox"
}