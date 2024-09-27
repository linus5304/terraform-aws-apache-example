data "aws_vpc" "main" {
  id = var.vpc_id
}


resource "aws_security_group" "sg_my_server" {
  name        = "sg_my_server"
  description = "MyServer Security Group"
  vpc_id      = data.aws_vpc.main.id

  ingress = [
    {
      description      = "HTTP"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
    {
      description      = "SSH"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["104.194.51.113/32"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  egress = [
    {
      description      = "outgoing traffic"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = var.public_key
}

resource "aws_instance" "my_server" {
  ami                    = "ami-0ebfd941bbafe70c6"
  instance_type          = var.instance_type
  key_name               = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.sg_my_server.id]
  user_data              = templatefile("${abspath(path.module)}/userdata.yaml", {})
  # provisioner "local-exec" {
  #   command = "echo ${self.private_ip} >> private_ips.txt"
  # }
  provisioner "file" {
    content     = "mars"
    destination = "/home/ec2-user/bacoon.txt"

    connection {
      type = "ssh"
      user = "ec2-user"
      # private_key = file("/Users/linusbayere/.ssh/terraform")
      private_key = var.private_key
      host        = self.public_ip
    }
  }

  tags = {
    Name = var.server_name
  }
}
