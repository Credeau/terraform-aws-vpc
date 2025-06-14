resource "aws_eip" "bastion" {
  tags = local.common_tags
}

resource "aws_instance" "bastion" {
  ami                         = var.bastion_ami_id != null ? var.bastion_ami_id : data.aws_ami.ubuntu.id
  instance_type               = var.bastion_instance_type
  subnet_id                   = aws_subnet.public[0].id # Placing in first public subnet
  key_name                    = var.bastion_key_name
  associate_public_ip_address = true

  vpc_security_group_ids = [
    aws_security_group.bastion_sg.id
  ]

  tags = merge(
    local.common_tags,
    {
      Name = format("%s-bastion", local.stack_identifier)
    }
  )
}

resource "aws_eip_association" "bastion" {
  instance_id   = aws_instance.bastion.id
  allocation_id = aws_eip.bastion.id
}
