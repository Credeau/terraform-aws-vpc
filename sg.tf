resource "aws_security_group" "internal_sg" {
  name        = format("%s-vpc-internal-sg", local.stack_identifier)
  description = format("Allow internal traffic in %s-vpc", var.application)
  vpc_id      = aws_vpc.main.id

  dynamic "ingress" {
    for_each = var.internal_sg_ingress_conf
    content {
      description = ingress.value.description
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr
    }
  }

  ingress {
    description = "Allow all traffic from self"
    from_port   = 0
    protocol    = -1
    to_port     = 0
    self        = true
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr] // Allow access from within the VPC
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(
    local.common_tags,
    {
      Name : format("%s-vpc-internal-sg", local.stack_identifier)
    }
  )
}

resource "aws_security_group" "external_sg" {
  name        = format("%s-vpc-external-sg", local.stack_identifier)
  description = format("Allow external traffic in %s-vpc", var.application)
  vpc_id      = aws_vpc.main.id

  dynamic "ingress" {
    for_each = var.external_sg_ingress_conf
    content {
      description = ingress.value.description
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr
    }
  }

  ingress {
    description = "Allow all traffic from self"
    from_port   = 0
    protocol    = -1
    to_port     = 0
    self        = true
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(
    local.common_tags,
    {
      Name : format("%s-vpc-external-sg", local.stack_identifier)
    }
  )
}

resource "aws_security_group" "bastion_sg" {
  name        = format("%s-vpc-bastion-sg", local.stack_identifier)
  description = format("Allow bastion traffic in %s-vpc", var.application)
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Allow all traffic from self"
    from_port   = 0
    protocol    = -1
    to_port     = 0
    self        = true
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(
    local.common_tags,
    {
      Name : format("%s-vpc-bastion-sg", local.stack_identifier)
    }
  )
}
