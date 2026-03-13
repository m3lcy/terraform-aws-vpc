locals {
  public_subnets = {
    for k, s in aws_subnet.enterprise_subnets : k => s if s.map_public_ip_on_launch
  }

  public_subnet_azs = distinct([for s in local.public_subnets : s.availability_zone])

  public_subnet_by_az = {
    for az in local.public_subnet_azs :
    az => element([for s in local.public_subnets : s.id if s.availability_zone == az], 0)
  }
}

resource "aws_eip" "nat" {
  for_each = var.enable_nat_gateway ? local.public_subnet_by_az : {}
  domain   = "vpc"

  tags = {
    Name = "${var.name_prefix}-nat-eip"
  }
}

resource "aws_nat_gateway" "this" {
  for_each      = var.enable_nat_gateway ? local.public_subnet_by_az : {}
  allocation_id = aws_eip.nat[each.key].id
  subnet_id     = each.value

  tags = {
    Name = "${var.name_prefix}-nat-gw"
  }

  depends_on = [aws_internet_gateway.this]
}