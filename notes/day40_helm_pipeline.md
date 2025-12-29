# 📅 Daily Engineering Log
**Date:** 2025-12-28
**Focus:** AKS Deployment Pipeline · Helm · GitHub Actions · Azure RBAC

---

## 🧠 Objectives
- Stabilise AKS deployment workflow using Helm
- Clean up GitHub Actions YAML for dev/test environments
- Validate Azure OIDC login and cluster access
- Reduce RBAC-related friction during kubectl/helm operations

---

## ✅ Work Completed
- Reviewed and refined GitHub Actions workflow for AKS Helm deployments
  - Ensured stable Helm release naming
  - Added safer bash settings (`set -euo pipefail`)
  - Verified environment-based resource selection (dev/test)
- Validated Azure OIDC login via `azure/login@v2`
- Investigated Helm’s role in AKS deployments
  - Clarified Helm as a **package manager**, not a policy engine
- Debugged Kubernetes RBAC errors related to namespace and resource access
- Compared self-hosted vs `ubuntu-latest` runners for AKS workflows
- Generated commit messages aligned with infrastructure changes

---

## 🧪 Issues & Findings
- Azure RBAC (when `enable_azure_rbac = true`) strictly controls kubectl access
  - Missing role assignments can block namespace/serviceaccount reads
- Helm failures often surfaced as Kubernetes permission issues, not Helm bugs
- Workflow YAML errors were mostly structural, not logic-related
- Self-hosted runners add power but also add “you own the sharp edges”

---

## 📚 Concepts Reinforced
- Helm = versioned, repeatable Kubernetes deployments
- AKS + Azure RBAC ≠ Kubernetes RBAC (they overlap, they do not merge)
- GitHub Actions OIDC is stable, secure, and worth the setup cost
- CI/CD YAML is code: small mistakes, big consequences

---

## 🔜 Next Steps
- Finalise test environment AKS deployment pipeline
- Apply least-privilege Azure RBAC roles for AKS access
- Add Helm `lint` and `template` steps to CI for earlier failure detection
- Prepare baseline NGINX Ingress setup for dev

---

## 🧭 Engineering Note
Today was less about shipping and more about **understanding the machinery**.
That’s not a delay—that’s compound interest.
