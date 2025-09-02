locals {
  ports       = var.sg_ports
  cidrs       = var.sg_cidr_blocks
  rules_tuple = setproduct(local.ports, local.cidrs)
  rules = {
    for pair in local.rules_tuple :
    "${pair[0]}-${pair[1]}" => pair
  }
}

resource "aws_security_group_rule" "main" {
  for_each                 = local.rules
  type                     = var.sg_type
  description              = var.sg_description
  security_group_id        = var.sg_id
  cidr_blocks              = [each.value[1]]
  protocol                 = var.sg_protocol
  from_port                = each.value[0]
  to_port                  = each.value[0]
  ipv6_cidr_blocks         = var.sg_ipv6_cidr_blocks
  self                     = var.sg_self
  source_security_group_id = var.sg_source_sg_id
}