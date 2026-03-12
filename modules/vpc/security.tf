resource "aws_security_group" "management" {
  name        = "${var.name_prefix}-mgmt-sg"
  description = "Management Services"
  vpc_id      = aws_vpc.this.id

  tags = {
    Name = "mgmt-sg"
  }
}

resource "aws_security_group" "compute" {
  name        = "${var.name_prefix}-compute-sg"
  description = "High-Bandwidth Workloads"
  vpc_id      = aws_vpc.this.id

  tags = {
    Name = "compute-sg"
  }
}

resource "aws_security_group" "enterprise_internal" {
  name        = "${var.name_prefix}-internal-sg"
  description = "Core, R&D, and Employee Services"
  vpc_id      = aws_vpc.this.id

  tags = {
    Name = "internal-sg"
  }
}

resource "aws_security_group" "guest" {
  name        = "${var.name_prefix}-guest-sg"
  description = "Guest Traffic"
  vpc_id      = aws_vpc.this.id

  tags = {
    Name = "guest-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "mgmt_ssh" {
  for_each = { for idx, cidr in var.management_ssh_cidrs : idx => cidr }

  security_group_id = aws_security_group.management.id
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  cidr_ipv4         = each.value
}

resource "aws_vpc_security_group_ingress_rule" "mgmt_to_compute" {
  security_group_id            = aws_security_group.compute.id
  from_port                    = 22
  to_port                      = 22
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.management.id
}

resource "aws_vpc_security_group_egress_rule" "all_outbound" {
  for_each = {
    mgmt     = aws_security_group.management.id
    compute  = aws_security_group.compute.id
    internal = aws_security_group.enterprise_internal.id
    guest    = aws_security_group.guest.id
  }

  security_group_id = each.value
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}