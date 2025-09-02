# fng-devops (Dev EKS + TLS via cert-manager + public NLB)

This repo sets up:
- EKS (Spot nodes) in your existing VPC (referenced as `module.fng-dev-vpc`)
- Ingress: **ingress-nginx** with **one public NLB**
- TLS: **cert-manager + Let's Encrypt** (DNS-01 with Route53)
- Apps: web (3000) and api (3001), exposed via Ingress with HTTPS
- Argo CD & kube-prometheus-stack are included with Ingresses, also behind the same NLB

### About GitOps
The manifests under `clusters/dev/k8s/apps/` and `clusters/dev/k8s/monitoring/` are **plain Kubernetes/Helm configs** intended to be applied with `kubectl`/`helm` for now.  
They are **not** Argo CD `Application` manifests yet. If you want full GitOps, we can add a `gitops/` folder with Argo CD Applications (App-of-Apps) so Argo CD manages these components declaratively.

---

## Prereqs
- AWS CLI v2, Terraform >= 1.6, kubectl, Helm 3
- An **existing** VPC Terraform module exported as `module.fng-dev-vpc` with `public_subnet` and `private_subnet` outputs
- Route53 public hosted zone for `hw-fng.com` and its Hosted Zone ID
- ECR images pushed: `fng-web:feature-login` and `fng-api:feature-login`

---

## 1) Provision EKS & IAM (Terraform)

```bash
cd infra/terraform
terraform init
terraform apply -auto-approve -var 'route53_zone_id=ZXXXXXXXXXXXX' -var 'admin_cidrs=["YOUR.IP/32"]'
```

Configure kubectl:
```bash
aws eks update-kubeconfig --region us-east-1 --name fng-dev-eks
kubectl get nodes -o wide
```

---

## 2) Namespaces
```bash
kubectl apply -f clusters/dev/k8s/namespaces.yaml
```

---

## 3) Ingress controller (creates the public NLB)
```bash
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx       -n ingress-nginx       -f clusters/dev/k8s/ingress-nginx/values.yaml

# Get the NLB DNS name
kubectl -n ingress-nginx get svc ingress-nginx-controller -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'; echo
```

---

## 4) cert-manager (TLS) with IRSA

```bash
helm repo add jetstack https://charts.jetstack.io
helm repo update

CM_ROLE_ARN=$(terraform -chdir=infra/terraform output -raw cert_manager_irsa_role_arn)

helm upgrade --install cert-manager jetstack/cert-manager       -n cert-manager --create-namespace       --set crds.enabled=true       --set serviceAccount.name=cert-manager       --set serviceAccount.create=true       --set-json 'serviceAccount.annotations={"eks.amazonaws.com/role-arn":"'"$CM_ROLE_ARN"'"}'

kubectl apply -f clusters/dev/k8s/cert-manager/cluster-issuer.yaml
```

---

## 5) Argo CD (optional UI) with HTTPS

```bash
helm repo add argo https://argoproj.github.io/argo-helm
helm repo update
helm upgrade --install argocd argo/argo-cd       -n argocd -f clusters/dev/k8s/argocd/values.yaml

kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d; echo
```

---

## 6) Monitoring (Prometheus + Grafana) with HTTPS

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm upgrade --install monitoring prometheus-community/kube-prometheus-stack       -n monitoring -f clusters/dev/k8s/monitoring/values.yaml
```

---

## 7) Deploy apps (web + api) with HTTPS
- Edit the `image:` fields in:
  - `clusters/dev/k8s/apps/web-deployment.yaml`
  - `clusters/dev/k8s/apps/api-deployment.yaml`
- Apply:
```bash
kubectl apply -f clusters/dev/k8s/apps/api-deployment.yaml
kubectl apply -f clusters/dev/k8s/apps/web-deployment.yaml
```

---

## 8) Route53 records (Terraform)
After ingress-nginx is up, update `infra/terraform/route53.auto.tfvars` using the example file:

```bash
cp infra/terraform/route53.auto.tfvars.example infra/terraform/route53.auto.tfvars
# Fill in:
# - route53_zone_id (your hosted zone)
# - lb_dns_name     (from step 3)
# - lb_zone_id      (via AWS CLI below)
```

Get the NLB CanonicalHostedZoneId:
```bash
aws elbv2 describe-load-balancers       --query 'LoadBalancers[?DNSName==`<YOUR_NLB_DNS>`].CanonicalHostedZoneId'       --output text
```

Create the records:
```bash
terraform -chdir=infra/terraform apply -auto-approve
```

Hosts created:
- `argocd.hw-fng.com`
- `grafana.hw-fng.com`
- `prometheus.hw-fng.com`
- `web.hw-fng.com`
- `api.hw-fng.com`

Certificates are issued automatically by cert-manager (DNS-01), and terminate at NGINX.

---

## Quick reference (what's what)
- **infra/terraform/**
  - `eks.tf` — EKS, Spot node group, core addons (EBS CSI), IRSA enabled.
  - `iam-cert-manager.tf` — IRSA role + least-priv Route53 policy for DNS-01.
  - `route53-records.tf` — A/ALIAS records to your NLB for 5 hostnames.
  - `subnet-tags.tf` — subnet discovery tags for Kubernetes/NLB.
  - `variables.tf` — region, cluster name/version, CIDRs, hosted zone, domain, LB fields.
  - `outputs.tf` — useful outputs (incl. cert-manager role ARN).
- **clusters/dev/k8s/**
  - `namespaces.yaml` — creates required namespaces.
  - `ingress-nginx/values.yaml` — NGINX Ingress Controller with public NLB.
  - `cert-manager/cluster-issuer.yaml` — Let’s Encrypt DNS-01 cluster-wide issuer.
  - `argocd/values.yaml` — Argo CD via NGINX with cert-manager TLS.
  - `monitoring/values.yaml` — Prometheus+Grafana via NGINX with cert-manager TLS.
  - `apps/` — Web & API Deployments/Services/Ingress (HTTPS).

### Next (optional)
- Convert to full **GitOps** by adding Argo CD `Application` manifests.
- Add **ExternalDNS** to automate Route53 records from Ingress, if desired.
