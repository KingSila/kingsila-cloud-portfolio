# Daily Log – 2025-12-26

## Focus
Stabilise **AKS test environment deployment pipeline** with:
- Private AKS access
- NGINX ingress
- Azure AD + Kubernetes RBAC
- NetworkPolicies
- Reliable in-cluster smoke tests

---

## What Was Accomplished

### ✅ Pipeline & Auth
- Confirmed AKS is **AAD-managed with Kubernetes RBAC** (not Azure RBAC for K8s).
- Fixed pipeline identity access by:
  - Creating `ClusterRoleBinding` for pipeline service principal.
  - Separating Azure control-plane permissions from Kubernetes RBAC.
- Standardised use of **`az aks command invoke`** for private cluster safety.

### ✅ Networking & Security
- Identified `default-deny-all` NetworkPolicy as root cause of 504s.
- Implemented minimal, explicit allow rules:
  - `allow-dns-egress`
  - `allow-egress-within-test`
  - `allow-test-to-app`
  - `allow-ingress-nginx-to-app`
- Verified traffic flow:
  - Pod → Service ✅
  - Ingress → Service → Pod ✅

### ✅ Ingress
- Fixed malformed Ingress (missing `http.paths`).
- Confirmed correct `ingressClassName: nginx`.
- Diagnosed 404s as **Host mismatch**, not controller failure.
- Updated pipeline to **read ingress host dynamically** instead of hardcoding.
- Verified NGINX reloads and backend routing via controller logs.

### ✅ CI/CD Hygiene
- Fixed multiple YAML parsing issues:
  - Removed duplicated / mis-indented steps.
  - Eliminated inline heredocs that broke GitHub Actions YAML.
  - Quoted all `name:` fields containing `:` to avoid parser errors.
- Standardised step naming:
