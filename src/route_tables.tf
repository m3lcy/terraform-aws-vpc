resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = merge(
    var.common_tags,
    {
      Name = "${var.name_prefix}-public-route"
    }
  )
}

resource "aws_route_table_association" "public" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  for_each = var.enable_nat_gateway ? aws_subnet.private : [] # only create route tables when NAT is enabled
  vpc_id   = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat[each.key].id
  }

  tags = merge(
    var.common_tags,
    {
      Name = "${var.name_prefix}-private-route-${each.key}"
    }
  )
}

resource "aws_route_table_association" "private" {
  for_each       = var.enable_nat_gateway ? aws_subnet.private : [] # only create associations when NAT is enabled
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private[each.key].id
}