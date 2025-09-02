##########################################################
#Module: Route 53 Record
#
#Index:
#- Create Record Simple
##########################################################

resource "aws_route53_record" "main" {
  name    = var.route53_record_name
  type    = var.route53_record_type
  zone_id = var.route53_zone_id
  ttl     = var.route53_ttl
  records = [var.route53_records]
}