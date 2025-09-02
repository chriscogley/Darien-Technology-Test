output "subnet_netmasks" {
  value = module.subnet_calculator.network_cidr_blocks
}

output "id" {
  value = aws_vpc.main.id
}

output "arn" {
  value = aws_vpc.main.arn
}

output "cidr_block" {
  value = aws_vpc.main.cidr_block
}

output "private_subnet" {
  value = aws_subnet.private[*].id
}

output "public_subnet" {
  value = aws_subnet.public[*].id
}