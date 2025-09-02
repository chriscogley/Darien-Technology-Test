output "cluster_name"            { value = module.eks.cluster_name }
output "cluster_endpoint"        { value = module.eks.cluster_endpoint }
output "cluster_oidc_issuer_url" { value = module.eks.cluster_oidc_issuer_url }
output "oidc_provider_arn"       { value = module.eks.oidc_provider_arn }
output "cert_manager_irsa_role_arn" { value = aws_iam_role.cert_manager.arn }
