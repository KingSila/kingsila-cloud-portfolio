# 🚀 12-Week Platform Engineering Tracker (Updated 2025-12-26)
**Azure · Terraform · GitHub Actions · AKS · SRE**

---

## ✅ Weeks 1–2: Platform CI/CD & IaC Foundations
**Status: 100% Complete**

Achievements:
- Standardised GitHub Actions workflow for Terraform
- Implemented OIDC authentication with Azure
- Reusable CI pipeline templates
- Artifact upload & naming fixes
- GitHub Environments for dev/test/prod/destroy
- Branch protection on `main`
- Pre-commit hooks (fmt, validate, tflint, md-lint)
- Environment lifecycle tooling + VS Code tasks
- CI/CD documentation (`/docs/cicd.md`)
- Drift detection scaffolding
- End-to-end stable plan/apply workflow
- Secret flow: GitHub → Terraform → Key Vault
- App Service + Insights + telemetry validation

---

## ✅ Weeks 3–4: IaC Governance & Multi-Environment Foundations
**Status: 100% Complete**

Achievements:
- Stable backend keys for all environments
- Fixed `for_each` structure issues
- Remote state for dev/test/prod
- Reusable modules (networking, keyvault, policy)
- Destroy protections + approvals
- Tagging & cost governance groundwork
- Management groups + RBAC scaffolding
- Resolved drift issues
- Finalised environment lifecycle model
- Central Key Vault pattern implemented
- RBAC for CI (management + data plane)
- App Service Key Vault references completed

---

## 🛡️ Weeks 5–6: Security, Compliance & Guardrails
**Status: 100% Complete**

Completed:
- Azure Policy-as-Code (allowed locations, SKU restrictions)
- Reusable policy-assignment module
- Defender for Cloud baseline enabled
- Workload identity pattern across environments
- tfsec scanning (non-blocking + blocking modes)
- Checkov scanning with SARIF export
- Tag enforcement (owner/environment)
- Secret provisioning stabilised (dev/test/prod)
- App Service + KV + telemetry integration validated
- Destroy pipeline with env-specific backend config
- Hardened Key Vault `network_acls` (tfsec CRITICAL resolved)
- Added “deny public endpoints” policies
- Security architecture documentation drafted (`/docs/security.md`)
- Defender leftover state validated

---

## ☸️ Weeks 7–8: AKS Platform Layer — Actively Under Construction
**Status: ~30% Complete**

### Completed / In Progress
- [x] AKS module outputs (cluster name, node RG, OIDC issuer URL)
- [x] Dev Kubernetes manifests created
  - Namespace
  - ServiceAccount
  - Deployment (hardened security context)
- [x] Dev AKS cluster lifecycle exercised (create / destroy / recover)
- [x] Initial ingress-nginx controller deployed in dev
- [x] GitHub Actions groundwork for AKS deploy pipeline (dev/test split)
- [ ] Workload identity end-to-end test (AKS → Azure)
- [ ] Stabilise ingress access pattern for private AKS
- [ ] Prepare test environment AKS deployment pipeline (separate cluster + namespace)

### Remaining for Weeks 7–8
- AKS module enhancements (node pools, autoscaling, logging, metrics)
- Standardise namespace + baseline policies per environment
- Build base Helm “golden chart”
- Wire workload identity consistently across dev/test
- Runtime standards documentation (`/docs/platform-runtime.md`)

---

## 🔭 Weeks 9–10: Observability, SRE & Reliability
**Status: 0% (Not Started)**

Planned:
- AKS metrics, logs, and traces
- Application Insights + Container Insights alignment
- Grafana dashboards
- HPA, readiness/liveness probes, PDBs
- Alerting rules (cluster + workload)
- SLO definitions
- Reliability documentation (`/docs/sre.md`)

---

## 🎨 Weeks 11–12: Platform Packaging & Career Positioning
**Status: 0% (Not Started)**

Planned:
- Architecture diagrams (Hub-Spoke + AKS + CI/CD)
- Platform overview in README
- 10-minute internal-style presentation
- Promotion narrative
- CV updates
- Optional: article or recorded walkthrough

---

# 📊 Overall Progress

**Current Progress:** **~72%**

### Breakdown:
- Weeks 1–4 → **100%**
- Weeks 5–6 → **100%**
- Weeks 7–8 → **~30% in progress**
- Weeks 9–12 → **0%**

---

# 📌 Snapshot Summary

### ✔ Completed to Date
- End-to-end CI/CD for Terraform
- Multi-environment IaC architecture
- Azure identity + Key Vault patterns
- Policy-as-Code and security scanning
- Governance guardrails
- AKS cluster foundation + dev workloads

### 🚀 In Progress
- AKS workload identity validation
- Ingress hardening for private AKS
- Dev/test AKS deployment pipelines
- Runtime standardisation

### 🔜 Coming Next
- Helm golden chart
- Production-grade ingress
- AKS app delivery pipeline
- Observability and SRE patterns
