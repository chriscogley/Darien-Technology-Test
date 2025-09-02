resource "aws_db_option_group" "main" {
  name = var.rds_name
  option_group_description = var.rds_description
  engine_name          = var.rds_engine
  major_engine_version = var.rds_major_engine_version
  option {
    option_name = var.rds_option_name
    option_settings {
      name  = var.rds_option_setting_name
      value = var.rds_option_setting_value
    }
    port = var.rds_port
    version = var.rds_version
    db_security_group_memberships = [var.rds_db_sg_memberships]
    vpc_security_group_memberships = [var.rds_vpc_sg_memberships]
  }

  tags = {
    Name = var.rds_name
  }
}