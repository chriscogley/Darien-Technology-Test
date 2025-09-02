resource "aws_elasticache_cluster" "main" {
  cluster_id      = var.cache_cluster_id
  engine          = "redis"
  engine_version  = var.cache_engine_version
  node_type       = var.cache_node_type
  num_cache_nodes = var.cache_num_cache_nodes

  parameter_group_name       = var.cache_parameter_group_name
  subnet_group_name          = var.cache_subnet_group_name
  network_type             = var.cache_network_type
  replication_group_id     = var.cache_replication_group_id
  security_group_ids       = [var.cache_security_group_ids]
  port                     = var.cache_port
  availability_zone          = var.cache_availability_zone
  apply_immediately          = var.cache_apply_immediately
  auto_minor_version_upgrade = var.cache_auto_minor_version_upgrade
  log_delivery_configuration {
    destination      = var.cache_log_destination
    destination_type = var.cache_log_destination_type
    log_format       = var.cache_log_format
    log_type         = var.cache_log_type
  }
  maintenance_window       = var.cache_maintenance_window
  notification_topic_arn   = var.cache_notification_topic_arn
  snapshot_retention_limit = 15
  snapshot_window          = var.cache_snapshot_window
  final_snapshot_identifier = var.cache_final_snapshot_identifier

  tags = {
    Name = var.cache_cluster_id
  }
}