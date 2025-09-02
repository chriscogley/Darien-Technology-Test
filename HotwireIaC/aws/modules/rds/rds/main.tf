##########################################################
#Module: RDS
#
#Index:
#- Instance Data
#- Storage
#- Security
#- Configuration
#- Backups
#- Monitoring
##########################################################

resource "aws_db_instance" "main" {
##### INSTANCE DATA
  identifier = var.rds_identifier
  db_name = var.rds_db_name
  instance_class = var.rds_instance_class
  engine = var.rds_engine
  engine_version = var.rds_engine_ver
  deletion_protection = true #RDS.8
  multi_az = var.rds_multi_az
  maintenance_window = var.rds_maintenance_window
  timezone = var.rds_timezone
  custom_iam_instance_profile = var.rds_custom_iam_profile
  auto_minor_version_upgrade = "true" #RDS.13
  allow_major_version_upgrade = var.rds_allow_major_version_upgrade
  apply_immediately = var.rds_apply_immediately
###### STORAGE
  allocated_storage = var.rds_allocated_storage
  max_allocated_storage = var.rds_max_allocated_storage
  storage_encrypted = "true" #RDS.3
  storage_type = var.rds_storage_type
  storage_throughput = var.rds_storage_throughput
  iops = var.rds_iops
##### SECURITY
  username = var.rds_username #RDS.25
  manage_master_user_password = "true"
  port = var.rds_port #RDS.23
  publicly_accessible = "false" #RDS.2
  availability_zone = var.rds_az #RDS.5
  db_subnet_group_name = var.rds_subnet_group #RDS.1 RDS.5 RDS.18
  vpc_security_group_ids = [var.rds_sg_ids]
  enabled_cloudwatch_logs_exports = [var.rds_cw_logs_exports] #RDS.9
  iam_database_authentication_enabled = true #RDS.12
  ca_cert_identifier = var.rds_ca_cert_identifier
##### CONFIGURATION
  option_group_name = var.rds_option_group
  parameter_group_name = var.rds_parameter_group
##### BACKUPS
  backup_retention_period = var.rds_backup_retention #RDS.11
  copy_tags_to_snapshot = "true" #RDS.17
  delete_automated_backups = var.rds_delete_auto_backups
  final_snapshot_identifier = var.rds_final_snapshot
##### MONITORING
  monitoring_interval = var.rds_monitoring_interval #RDS.6
  monitoring_role_arn = var.rds_monitoring_role_arn
  performance_insights_enabled = var.rds_performance_insights
  performance_insights_retention_period = var.rds_performance_insights_retention

  tags = {
    Name = var.rds_identifier
  }

}