# Create A/ALIAS records for each public hostname pointing to the ingress-nginx NLB
# Provide lb_dns_name and lb_zone_id in variables or tfvars once the NLB exists.

locals {
  hostnames = [
    "argocd",
    "grafana",
    "prometheus",
    "web",
    "api",
  ]
}

resource "aws_route53_zone" "hw-fng_com" {
  name          = "hw-fng.com"
  force_destroy = false

  tags = {
    Name = "hw-fng.com"
  }
}

resource "aws_route53_record" "hw-fng-com_demo" {
  name    = "demo.hw-fng.com"
  type    = "A"
  zone_id = aws_route53_zone.hw-fng_com.id
  records = ["54.197.223.2"]
  ttl     = 300
}

resource "aws_route53_record" "hw-fng-com_web" {
  name    = "web.hw-fng.com"
  type    = "CNAME"
  zone_id = aws_route53_zone.hw-fng_com.id
  records = ["afd23f614b56c4fc9a727436f9a16d65-70933908a423f276.elb.us-east-1.amazonaws.com"]
  ttl     = 300
}

resource "aws_route53_record" "hw-fng-com_api" {
  name    = "api.hw-fng.com"
  type    = "CNAME"
  zone_id = aws_route53_zone.hw-fng_com.id
  records = ["afd23f614b56c4fc9a727436f9a16d65-70933908a423f276.elb.us-east-1.amazonaws.com"]
  ttl     = 300
}




# resource "aws_route53_record" "aliases" {
#   for_each = toset(local.hostnames)
#   zone_id  = aws_route53_zone.hw-fng_com.id
#   name     = "${each.value}.${var.domain}"
#   type     = "A"
#
#   alias {
#     name                   = var.lb_dns_name
#     zone_id                = var.lb_zone_id
#     evaluate_target_health = false
#   }
# }
