# -----------------------------------------------
# Public
# -----------------------------------------------
resource "aws_internet_gateway" "public" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    local.common_tags,
    {
      Name : format("%s-internet-gateway", local.stack_identifier)
    }
  )
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.public.id
  }

  tags = merge(
    local.common_tags,
    {
      Name : format("%s-public-routes", local.stack_identifier)
    }
  )
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# -----------------------------------------------
# Private
# -----------------------------------------------

resource "aws_eip" "private" {
  tags = local.common_tags
}

resource "aws_nat_gateway" "private" {
  allocation_id     = aws_eip.private.id
  connectivity_type = "public"
  subnet_id         = aws_subnet.public[0].id

  tags = merge(
    local.common_tags,
    {
      Name : format("%s-nat-gateway", local.stack_identifier)
    }
  )

  depends_on = [aws_internet_gateway.public]
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    local.common_tags,
    {
      Name : format("%s-private-routes", local.stack_identifier)
    }
  )
}

resource "aws_route" "private_default_route" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.private.id
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}
