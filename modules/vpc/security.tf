resource "aws_security_group" "management" {
  name        = "${var.environment}-${var.name_prefix}-mgmt-sg"
  description = "Management Services"
  vpc_id      = aws_vpc.this.id

  tags = {
    Name = "mgmt-sg"
  }
}

resource "aws_security_group" "compute" {
  name        = "${var.environment}-${var.name_prefix}-compute-sg"
  description = "High-Bandwidth Workloads"
  vpc_id      = aws_vpc.this.id

  tags = {
    Name = "compute-sg"
  }
}

resource "aws_security_group" "enterprise_internal" {
  name        = "${var.environment}-${var.name_prefix}-internal-sg"
  description = "Core, R&D, and Employee Services"
  vpc_id      = aws_vpc.this.id

  tags = {
    Name = "internal-sg"
  }
}

resource "aws_security_group" "guest" {
  name        = "${var.environment}-${var.name_prefix}-guest-sg"
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

  tags = {
    Name = "mgmt-ssh"
  }
}

resource "aws_vpc_security_group_ingress_rule" "mgmt_to_compute" {
  security_group_id            = aws_security_group.compute.id
  from_port                    = 22
  to_port                      = 22
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.management.id

  tags = {
    Name = "mgmt-to-compute"
  }
}

resource "aws_vpc_security_group_ingress_rule" "compute_from_internal_https" {
  security_group_id            = aws_security_group.compute.id
  from_port                    = 443
  to_port                      = 443
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.enterprise_internal.id

  tags = {
    Name = "compute-from-internal-https"
  }
}

resource "aws_vpc_security_group_ingress_rule" "compute_from_internal_app" {
  security_group_id            = aws_security_group.compute.id
  from_port                    = 8080
  to_port                      = 8080
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.enterprise_internal.id

  tags = {
    Name = "compute-from-internal-app"
  }
}

resource "aws_vpc_security_group_ingress_rule" "internal_from_mgmt_ssh" {
  security_group_id            = aws_security_group.enterprise_internal.id
  from_port                    = 22
  to_port                      = 22
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.management.id

  tags = {
    Name = "internal-from-mgmt-ssh"
  }
}

resource "aws_vpc_security_group_ingress_rule" "guest_http" {
  security_group_id = aws_security_group.guest.id
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"

  tags = { Name = "guest-inbound-http" }
}

resource "aws_vpc_security_group_ingress_rule" "guest_https" {
  security_group_id = aws_security_group.guest.id
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"

  tags = { Name = "guest-inbound-https" }
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

resource "aws_vpc_security_group_ingress_rule" "mgmt_from_trusted_cidrs" {
  for_each = { for idx, cidr in var.trusted_cidrs : idx => cidr }

  security_group_id = aws_security_group.management.id
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  cidr_ipv4         = each.value

  tags = { Name = "mgmt-from-trusted-cidr-${each.key}" }
}