##########################################################
#Module: Route 53 Zone
#
#Index:
#- Create Hosted Zone
##########################################################

resource "aws_route53_zone" "private" {
  name    = var.dns_zone_name
  comment = var.zone_comment

  vpc {
    vpc_id     = var.vpc_id
    vpc_region = var.vpc_region
  }

  tags = {
    Name = var.dns_zone_name
  }
}