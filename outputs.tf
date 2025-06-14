# vpc id
output "vpc_id" {
  value = aws_vpc.main.id
}

# public subnet id's
output "public_subnets" {
  value = aws_subnet.public.*.id
}

# private subnet id's
output "private_subnets" {
  value = aws_subnet.private.*.id
}

# internal security group id
output "internal_security_group" {
  value = aws_security_group.internal_sg.id
}

# external security group id
output "external_security_group" {
  value = aws_security_group.external_sg.id
}

# bastion external security group id
output "bastion_security_group" {
  value = aws_security_group.bastion_sg.id
}

# nat gateway id
output "nat_gateway_id" {
  value = aws_nat_gateway.private.id
}

# internet gateway id
output "internet_gateway_id" {
  value = aws_internet_gateway.public.id
}

# public ip address of nat gateway
output "nat_public_ip" {
  value = aws_eip.private.public_ip
}

# public ip address of bastion
output "bastion_host" {
  value = aws_eip.bastion.public_ip
}