# 🚀 12-Week Platform Engineering Tracker (Updated 2025-12-18)
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

## ☸️ Weeks 7–8: AKS Platform Layer — Foundations Started
**Status: ~15% Complete**

### New Progress (from GitHub Kanban)
- [x] Added outputs to AKS module (cluster name, node RG, OIDC URL)
- [x] Created dev Kubernetes manifests (namespace, SA, Deployment)
- [ ] Test workload identity end-to-end in AKS
- [ ] Configure NGINX ingress baseline for dev
- [ ] Prepare test environment AKS deployment pipeline

### Remaining for Weeks 7–8
- AKS module enhancements (node pools, logging, metrics)
- Build base Helm “golden chart”
- Implement ingress & workload identity wiring across environments
- Document deployment standards (`/docs/platform-runtime.md`)

---

## 🔭 Weeks 9–10: Observability, SRE & Reliability
**Status: 0% (Not Started)**

Planned:
- Metrics/logs/tracing for AKS + workloads
- Grafana / App Insights dashboards
- HPA, readiness/liveness probes, PDBs
- Alert rules for cluster + apps
- SLO definitions
- Reliability docs (`/docs/sre.md`)

---

## 🎨 Weeks 11–12: Platform Packaging & Career Positioning
**Status: 0% (Not Started)**

Planned:
- Architecture diagrams (Hub-Spoke + AKS + CI/CD)
- Platform Overview in README
- 10-minute internal presentation
- Promotion narrative
- CV updates
- Optional: publish article + record walkthrough

---

# 📊 Overall Progress

**Current Progress:** **70%**
(up from ~65% after completing all Week 5–6 items and starting Weeks 7–8)

### Breakdown:
- Weeks 1–4 → **100%**
- Weeks 5–6 → **100%**
- Weeks 7–8 → **~15% in progress**
- Weeks 9–12 → **0%**

---

# 📌 Snapshot Summary

### ✔ Completed to date
- CI/CD automation
- Multi-env Terraform architecture
- Azure identity + Key Vault patterns
- Azure Policy-as-Code
- Security scanning (tfsec + Checkov)
- App Service + Insights + KV integration
- Full governance & security baseline

### 🚀 In Progress (Weeks 7–8)
- AKS workload identity test path
- AKS module outputs
- Dev Kubernetes manifests
- Ingress work starting
- Test env AKS pipeline preparation

### 🔜 Coming Next
- Helm golden chart
- Production-ready ingress
- AKS app pipeline
- Observability + dashboards
- Reliability patterns

---
