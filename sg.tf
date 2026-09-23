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
    description = "Allow all traffic from within the VPC"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = [var.vpc_cidr]
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

  # Some consumers of this module attach additional rules to internal_sg via
  # standalone aws_security_group_rule resources (e.g. security-group-source
  # rules, which internal_sg_ingress_conf cannot express since it only takes
  # cidr_blocks). Mixing inline ingress blocks with separate rule resources on
  # the same SG is unsupported by the AWS provider: the inline ingress list is
  # authoritative on apply and will revoke any rule not declared in it,
  # regardless of which resource created it. Ignoring post-creation drift on
  # ingress is the documented workaround, so externally-managed rules survive
  # applies. This means internal_sg_ingress_conf is only honored on initial
  # creation -- changing it later requires tainting/recreating the SG.
  lifecycle {
    ignore_changes = [ingress]
  }
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
    cidr_blocks = var.bastion_allowed_cidrs
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
