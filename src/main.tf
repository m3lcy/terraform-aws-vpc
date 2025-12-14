data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  azs = slice(data.aws_availability_zones.available.names, 0, var.az_count)
}

resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr

  tags = merge(
    var.common_tags,
    var.vpc_tags,
    {
      Name = "${var.name_prefix}-vpc"
    }
  )
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(
    var.common_tags,
    {
      Name = "${var.name_prefix}-igw"
    }
  )
}

resource "aws_subnet" "public" {
  for_each                = toset(local.azs)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, index(local.azs, each.value))
  availability_zone       = each.value
  map_public_ip_on_launch = true

  tags = merge(
    var.common_tags,
    var.public_subnet_tags,
    {
      Name = "${var.name_prefix}-public-${each.value}"
    }
  )
}

resource "aws_subnet" "private" {
  for_each                = toset(local.azs)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, index(local.azs, each.value) + 10)
  availability_zone       = each.value
  map_public_ip_on_launch = false

  tags = merge(
    var.common_tags,
    var.private_subnet_tags,
    {
      Name = "${var.name_prefix}-private-${each.value}"
    }
  )
}