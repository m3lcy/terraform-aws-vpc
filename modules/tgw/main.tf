resource "aws_ec2_transit_gateway" "this" {
  description                     = "${var.name_prefix}-${var.environment}-tgw"
  amazon_side_asn                 = var.aws_asn
  default_route_table_association = "disable"
  default_route_table_propagation = "disable"

  tags = {
    Name        = "${var.name_prefix}-${var.environment}-tgw"
    Environment = var.environment
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "this" {
  for_each = var.vpc_attachments

  transit_gateway_id = aws_ec2_transit_gateway.this.id
  vpc_id             = each.value.vpc_id
  subnet_ids         = each.value.subnet_ids

  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false

  tags = {
    Name        = "${var.name_prefix}-${var.environment}-tgw-att-${each.key}"
    Environment = var.environment
  }
}

resource "aws_ec2_transit_gateway_route_table" "this" {
  for_each = toset(distinct(values(var.route_table_associations)))

  transit_gateway_id = aws_ec2_transit_gateway.this.id

  tags = {
    Name        = "${var.name_prefix}-${var.environment}-tgw-rt-${each.key}"
    Environment = var.environment
  }
}

resource "aws_ec2_transit_gateway_route_table_association" "this" {
  for_each = var.route_table_associations

  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.this[each.key].id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.this[each.value].id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "this" {
  for_each = {
    for pair in flatten([
      for att_key, rt_keys in var.route_table_propagations : [
        for rt_key in rt_keys : {
          key     = "${att_key}-${rt_key}"
          att_key = att_key
          rt_key  = rt_key
        }
      ]
    ]) : pair.key => pair
  }

  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.this[each.value.att_key].id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.this[each.value.rt_key].id
}