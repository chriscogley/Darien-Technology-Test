#!/usr/bin/env bash
set -euo pipefail
NS="ai"
DB_NAME="${DB_NAME:-openwebui}"
DB_USER="${DB_USER:-openwebui}"
DB_HOST="${DB_HOST:-postgresql.ai.svc.cluster.local}"
DB_PORT="${DB_PORT:-5432}"

if [[ -z "${PG_PASSWORD:-}" ]]; then
  echo "ERROR: PG_PASSWORD is required (export PG_PASSWORD='...')" >&2
  exit 1
fi

if ! command -v kubeseal >/dev/null 2>&1; then
  echo "ERROR: kubeseal not found. Install kubeseal first." >&2
  exit 1
fi

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

kubeseal --controller-namespace kube-system --controller-name sealed-secrets --fetch-cert > "${TMP_DIR}/pub-cert.pem"

cat > "${TMP_DIR}/pg-auth.yaml" <<YAML
apiVersion: v1
kind: Secret
metadata:
  name: pg-auth
  namespace: ${NS}
type: Opaque
stringData:
  password: "${PG_PASSWORD}"
YAML

kubeseal --cert "${TMP_DIR}/pub-cert.pem" --format yaml < "${TMP_DIR}/pg-auth.yaml" > manifests/secrets/pg-auth-sealed.yaml
echo "Wrote manifests/secrets/pg-auth-sealed.yaml"

DATABASE_URL="postgresql://${DB_USER}:${PG_PASSWORD}@${DB_HOST}:${DB_PORT}/${DB_NAME}"
cat > "${TMP_DIR}/openwebui-db.yaml" <<YAML
apiVersion: v1
kind: Secret
metadata:
  name: openwebui-db
  namespace: ${NS}
type: Opaque
stringData:
  DATABASE_URL: "${DATABASE_URL}"
YAML

kubeseal --cert "${TMP_DIR}/pub-cert.pem" --format yaml < "${TMP_DIR}/openwebui-db.yaml" > manifests/secrets/openwebui-db-sealed.yaml
echo "Wrote manifests/secrets/openwebui-db-sealed.yaml"

echo "Done. git add/commit/push manifests/secrets/*.yaml"
