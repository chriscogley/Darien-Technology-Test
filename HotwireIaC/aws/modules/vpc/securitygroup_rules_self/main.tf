resource "aws_security_group_rule" "main" {
  for_each                 = toset(var.sg_ports)
  type                     = var.sg_type
  description              = var.sg_description
  security_group_id        = var.sg_id
  cidr_blocks              = var.sg_cidr_blocks
  protocol                 = var.sg_protocol
  from_port                = each.value
  to_port                  = each.value
  ipv6_cidr_blocks         = var.sg_ipv6_cidr_blocks
  self                     = var.sg_self
  source_security_group_id = var.sg_source_sg_id
}