resource "aws_security_group" "Jenkins-sg" {
  name        = "Jenkins-amazonpro7-sg"
  description = "Open 22,443,80,8080,9000,9100,9090,3000"

  # Define a single ingress rule to allow traffic on all specified ports
  ingress = [
    for port in [22, 80, 443, 8080, 9000, 9100, 9090, 3000] : {
      description      = "TLS from VPC"
      from_port        = port
      to_port          = port
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Jenkins-amazonpro7-sg"
  }
}


resource "aws_instance" "web" {
  ami                    = "ami-020cba7c55df1f615"
  instance_type          = "t2.large"
  key_name               = "amikey"
  vpc_security_group_ids = [aws_security_group.Jenkins-sg.id]
  user_data              = templatefile("./install_jenkins.sh", {})

  tags = {
    Name = "amazonpro7-01"
  }
  root_block_device {
    volume_size = 30
  }
}

resource "aws_instance" "web2" {
  ami                    = "ami-020cba7c55df1f615"
  instance_type          = "t2.large"
  key_name               = "amikey"
  vpc_security_group_ids = [aws_security_group.Jenkins-sg.id]
  tags = {
    Name = "Monitering via grafana"
  }
  root_block_device {
    volume_size = 30
  }
}
