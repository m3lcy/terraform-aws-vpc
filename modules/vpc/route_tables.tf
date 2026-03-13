resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name = "${var.name_prefix}-public-rt"
  }
}

resource "aws_route_table" "private" {
  for_each = { for k, s in aws_subnet.enterprise_subnets : k => s if !s.map_public_ip_on_launch }
  vpc_id   = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this[each.value.availability_zone].id
  }

  tags = {
    Name = "${var.name_prefix}-private-rt-${each.key}"
  }
}

resource "aws_route_table_association" "enterprise_assoc" {
  for_each  = aws_subnet.enterprise_subnets
  subnet_id = each.value.id

  route_table_id = var.subnet_config[each.key].is_public ? aws_route_table.public.id : aws_route_table.private[each.key].id
}