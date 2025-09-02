output "dns" {
  description = "Get DNS name"
  value = aws_elasticache_cluster.main.cache_nodes[*].address
}