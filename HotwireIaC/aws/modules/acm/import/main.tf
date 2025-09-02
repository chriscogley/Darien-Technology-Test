resource "aws_acm_certificate" "main" {
  private_key       = var.acm_private_key
  certificate_body  = var.acm_certificate_body
  certificate_chain = var.acm_certificate_chain
}