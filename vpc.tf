resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true # gives you an internal domain name
  enable_dns_hostnames = true # gives you an internal host name
  instance_tenancy     = "default"

  tags = merge(
    local.common_tags,
    {
      Name : format("%s-vpc", local.stack_identifier)
    }
  )
}

resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidrs)

  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[count.index].cidr
  map_public_ip_on_launch = true
  availability_zone       = var.public_subnet_cidrs[count.index].az

  tags = merge(
    local.common_tags,
    {
      Name : format("%s-vpc-public-subnet-%s", local.stack_identifier, var.public_subnet_cidrs[count.index].az)
    }
  )
}

resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidrs)

  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_subnet_cidrs[count.index].cidr
  map_public_ip_on_launch = false
  availability_zone       = var.private_subnet_cidrs[count.index].az

  tags = merge(
    local.common_tags,
    {
      Name : format("%s-vpc-private-subnet-%s", local.stack_identifier, var.public_subnet_cidrs[count.index].az)
    }
  )
}
