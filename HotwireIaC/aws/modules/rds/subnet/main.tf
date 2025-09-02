resource "aws_db_subnet_group" "main" {
  name = var.rds_name
  description = "Subnet Group used by ${var.rds_name}"
  subnet_ids = var.rds_subnets

  tags = {
    Name = var.rds_name
  }
}