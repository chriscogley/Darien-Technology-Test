# locals {
#   public_subnet_ids  = module.fng-dev-vpc.public_subnet
#   private_subnet_ids = module.fng-dev-vpc.private_subnet
# }
#
# resource "aws_ec2_tag" "cluster_tag_public" {
#   for_each    = toset(local.public_subnet_ids)
#   resource_id = each.value
#   key         = "kubernetes.io/cluster/${var.cluster_name}"
#   value       = "shared"
# }
#
# resource "aws_ec2_tag" "cluster_tag_private" {
#   for_each    = toset(local.private_subnet_ids)
#   resource_id = each.value
#   key         = "kubernetes.io/cluster/${var.cluster_name}"
#   value       = "shared"
# }
#
# resource "aws_ec2_tag" "public_elb_role" {
#   for_each    = toset(local.public_subnet_ids)
#   resource_id = each.value
#   key         = "kubernetes.io/role/elb"
#   value       = "1"
# }
#
# resource "aws_ec2_tag" "private_elb_role" {
#   for_each    = toset(local.private_subnet_ids)
#   resource_id = each.value
#   key         = "kubernetes.io/role/internal-elb"
#   value       = "1"
# }