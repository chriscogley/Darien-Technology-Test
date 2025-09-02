data "aws_iam_policy_document" "cm_assume" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"
    principals {
      type        = "Federated"
      identifiers = [module.eks.oidc_provider_arn]
    }
    condition {
      test     = "StringEquals"
      variable = "${replace(module.eks.cluster_oidc_issuer_url, "https://", "")}:aud"
      values   = ["sts.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "${replace(module.eks.cluster_oidc_issuer_url, "https://", "")}:sub"
      values   = ["s-ystem:serviceaccount:cert-manager:cert-manager"]
    }
  }
}

resource "aws_iam_role" "cert_manager" {
  name               = "${var.eks_cluster_name}-cm-irsa"
  assume_role_policy = data.aws_iam_policy_document.cm_assume.json
}

r {
  statement {
    sid       = "AllowChangeRecordSetsInZone"
    effect    = "Allow"
    actions   = ["route53:ChangeResourceRecordSets"]
    resources = ["arn:aws:route53:::hostedzone/${var.route53_zone_id}"]
  }

  statement {
    sid    = "ReadZonesForDns01"
    effect = "Allow"
    actions = [
      "route53:ListHostedZonesByName",
      "route53:ListHostedZones",
      "route53:ListResourceRecordSets",
      "route53:GetChange"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "cert_manager_dns" {
  name   = "${var.eks_cluster_name}-cm-dns01"
  policy = data.aws_iam_policy_document.cm_dns.json
}

resource "aws_iam_role_policy_attachment" "cert_manager_dns_attach" {
  role       = aws_iam_role.cert_manager.name
  policy_arn = aws_iam_policy.cert_manager_dns.arn
}
