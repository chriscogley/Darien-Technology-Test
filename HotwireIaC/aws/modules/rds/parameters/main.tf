resource "aws_db_parameter_group" "main" {
  name = var.rds_name
  family = var.rds_family
  description = "Parameter Group used by ${var.rds_name}"
  parameter {
    name  = var.rds_parameter_name
    value = var.rds_parameter_value
    apply_method = var.rds_parameter_apply_method
  }

  tags = {
    Name = var.rds_name
  }
}
