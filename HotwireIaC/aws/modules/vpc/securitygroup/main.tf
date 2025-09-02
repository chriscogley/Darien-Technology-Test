resource "aws_security_group" "main" {
  name        = var.sg_name
  description = var.sg_description
  vpc_id      = var.sg_vpc

  tags = {
    Name = var.sg_name
  }
}