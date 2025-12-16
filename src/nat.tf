resource "aws_eip" "nat" {
  for_each = var.enable_nat_gateway ? aws_subnet.public : {}
  domain   = "vpc"

  tags = merge(
    var.common_tags,
    {
      Name = "${var.name_prefix}-nat-eip-${each.value.availability_zone}"
    }
  )

  depends_on = [aws_internet_gateway.this]
}

resource "aws_nat_gateway" "nat" {
  for_each      = var.enable_nat_gateway ? aws_subnet.public : {}
  allocation_id = aws_eip.nat[each.key].id
  subnet_id     = each.value.id

  tags = merge(
    var.common_tags,
    {
      Name = "${var.name_prefix}-nat-${each.value.availability_zone}"
    }
  )

  depends_on = [aws_internet_gateway.this]
}