output "dns" {
  description = "Get DNS name"
  value = aws_db_instance.main.address
}