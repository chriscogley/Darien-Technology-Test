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

---

## 9) Switch to GitOps (optional, when you’re ready)

These manifests are **not** Argo CD Applications by default. To let Argo CD own them:

1. Push this repo to Git and note its HTTPS URL (e.g., `https://github.com/your-org/fng-devops.git`).  
2. Edit the files in `gitops/` and replace **REPO_URL_HERE** with your repo URL.
3. If you already installed monitoring via Helm in step 6, uninstall it to avoid ownership conflicts:
   ```bash
   helm uninstall monitoring -n monitoring || true
   ```
   (Apps created with `kubectl` can be adopted by Argo without uninstalling.)
4. Apply the root Application (App-of-Apps):
   ```bash
   kubectl -n argocd apply -f gitops/root-app.yaml
   ```
5. Open Argo CD UI and watch **platform** create child apps:
   - **apps** → manages `clusters/dev/k8s/apps/` (web & api)
   - **monitoring** → installs kube-prometheus-stack with your inline values

From now on, change YAML in Git → Argo CD detects, compares, and syncs to the cluster.

### Rollbacks & image bumps with GitOps
- Bump images by editing `image:` tags in `clusters/dev/k8s/apps/*.yaml`, commit, push.
- Rollback by reverting the commit; Argo CD will sync back.


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

---

## 9) GitOps with Argo CD (two ways)

You can **run GitOps from the start** (recommended) or **switch later**.

### Option A — Run with GitOps from the start
Skip steps **5–7** (manual Helm/kubectl installs) and let Argo CD install everything.

1. Push this repo to Git and copy its HTTPS URL.
2. Replace placeholders:
   - In `gitops/*.yaml`, set **REPO_URL_HERE** to your repo URL.
   - In `gitops/cert-manager.yaml`, set **ROLE_ARN_HERE** to the Terraform output:
     ```bash
     terraform -chdir=infra/terraform output -raw cert_manager_irsa_role_arn
     ```
3. Apply the App-of-Apps:
   ```bash
   kubectl -n argocd apply -f gitops/root-app.yaml
   ```
4. Open Argo CD UI and watch the waves:
   - `platform-namespaces` (00) → creates namespaces
   - `ingress-nginx` (05) → public NLB
   - `cert-manager` (10) → CRDs + IRSA
   - `cert-issuers` (12) → Let’s Encrypt ClusterIssuer
   - `monitoring` (20) → kube-prometheus-stack
   - `apps` (30) → web & api

### Option B — Switch to GitOps later
If you already installed components manually, uninstall the Helm releases so Argo CD can own them:

```bash
helm uninstall monitoring -n monitoring || true
helm uninstall cert-manager -n cert-manager || true
helm uninstall ingress-nginx -n ingress-nginx || true
```

Then complete the same placeholder replacements as Option A and apply:
```bash
kubectl -n argocd apply -f gitops/root-app.yaml
```

Argo CD will re-install and then continuously reconcile from Git.
