resource "aws_db_event_subscription" "main" {
  name = var.rds_name
  sns_topic = var.rds_sns_topic
  source_ids = [var.rds_source_ids]
  source_type = var.rds_source_type
  event_categories = [var.rds_event_categories]
  enabled = var.rds_enabled

  tags = {
    Name = var.rds_name
  }
}