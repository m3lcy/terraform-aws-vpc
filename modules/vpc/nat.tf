locals {
  public_subnet_ids = [for s in aws_subnet.enterprise_subnets : s.id if s.map_public_ip_on_launch]
}

resource "aws_eip" "nat" {
  count  = var.enable_nat_gateway ? 1 : 0
  domain = "vpc"

  tags = {
    Name = "${var.name_prefix}-nat-eip"
  }
}

resource "aws_nat_gateway" "this" {
  count         = var.enable_nat_gateway ? 1 : 0
  allocation_id = aws_eip.nat[0].id
  subnet_id     = local.public_subnet_ids[0]

  tags = {
    Name = "${var.name_prefix}-nat-gw"
  }

  depends_on = [aws_internet_gateway.this]
}