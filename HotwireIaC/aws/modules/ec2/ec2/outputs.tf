output "arn" {
  description = "Get instance ARN"
  value = aws_instance.main.arn
}

output "id" {
  value = aws_instance.main.id
}

output "private_ip" {
  description = "Get the instance private IP"
  value = aws_instance.main.private_ip
}