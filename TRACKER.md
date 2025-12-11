# 12-Week Platform Engineering Tracker (Realigned 2025-12-11)
**Azure · Terraform · GitHub Actions · AKS · SRE**

---

## ✅ Weeks 1–2: Platform CI/CD & IaC Foundations (COMPLETED)

- [x] Standardised GitHub Actions workflow for Terraform
- [x] Implemented OIDC authentication with Azure
- [x] Created reusable CI pipeline templates
- [x] Fixed artifact upload & naming issues
- [x] Set up GitHub Environments (dev/test/prod/destroy)
- [x] Added branch protection for `main`
- [x] Enabled pre-commit hooks (fmt, validate, tflint, markdown lint)
- [x] Added environment lifecycle scripts + VS Code tasks
- [x] Documented CI/CD (`/docs/cicd.md`)
- [x] Added drift detection scaffolding
- [x] Fully stabilised plan/apply workflow across environments
- [x] Wired secrets flow from GitHub → Terraform → Key Vault
- [x] Added App Service + App Insights + telemetry validation

*Weeks 1–2 overshot the original plan — you’ve built a production-grade CI baseline.*

---

## ✅ Weeks 3–4: IaC Governance & Multi-Env Foundations (COMPLETED)

- [x] Refactored Terraform environments with stable backend keys
- [x] Fixed `for_each` list/map issues across modules
- [x] Integrated remote state for dev/test/prod
- [x] Created reusable modules (networking, key vault, policy)
- [x] Added destroy protections + approval workflow
- [x] Introduced tagging & cost governance groundwork
- [x] Added management groups + RBAC scaffolding
- [x] Solved environment drift issues
- [x] Finalised Environment Lifecycle workflow
- [x] Implemented **central Key Vault pattern** across environments
- [x] Fixed RBAC (management + data plane) for CI SP
- [x] Ensured App Service uses Key Vault references end-to-end

*Weeks 3–4 now correctly reflect your deep RBAC, identity, and Key Vault work.*

---

## 🛡️ Weeks 5–6: Security, Compliance & Platform Guardrails
**Status: ~85% completed**

### Completed
- [x] Finalised Azure Policy-as-Code (allowed locations, SKU restrictions)
- [x] Created reusable policy-assignment Terraform module
- [x] Enabled Defender for Cloud baseline
- [x] Centralised Key Vault + workload identity pattern (CI + App MI)
- [x] Implemented tfsec scanning in CI
  - Non-blocking GitHub Action with annotations
  - Blocking CLI enforcement mode for HIGH/CRITICAL
- [x] Implemented Checkov scanning in CI with working SARIF export
- [x] Implemented tag enforcement policies (owner/environment) at subscription scope
- [x] Stabilised end-to-end secret provisioning for dev/test/prod
- [x] Verified App Service / Key Vault / Telemetry pipeline working
- [x] Generated destroy pipeline YAML and integrated env-specific backend config

### Still To Do
- [x] Harden Key Vault `network_acls` (default deny, proper bypass/allow lists) to clear tfsec CRITICAL
- [ ] Document full security architecture (`/docs/security.md`
- [x] Add “deny public endpoints” policies

> Weeks 5–6 now show your real progress — the remaining work is polish and documentation, not heavy lifting.

---

## Weeks 7–8: App Platform Layer — AKS & Deployment Standards
**Not started (0%) — unchanged**

- [ ] Create AKS Terraform module (node pools, identity, logging)
- [ ] Deploy AKS to dev + integrate with VNet
- [ ] Build base Helm “golden chart”
- [ ] Build GitHub Actions pipeline for app → AKS
- [ ] Implement ingress, certs & workload identity
- [ ] Document golden deployment pattern (`/docs/platform-runtime.md`)

---

## Weeks 9–10: Observability, SRE & Platform Reliability
**Not started (0%) — unchanged**

- [ ] Add metrics/logs/tracing for AKS + workloads
- [ ] Create dashboards (Grafana/App Insights/Log Analytics)
- [ ] Implement HPA + readiness/liveness probes + PDBs
- [ ] Add alert rules (cluster + workloads)
- [ ] Define SLOs
- [ ] Document reliability standards (`/docs/sre.md`)

---

## Weeks 11–12: Platform Packaging & Career Positioning
**Not started (0%) — unchanged**

- [ ] Create architecture diagrams (Hub-Spoke + AKS + CI/CD)
- [ ] Write Platform Overview in README
- [ ] Prepare 10-minute internal presentation
- [ ] Draft promotion narrative
- [ ] Update CV with platform achievements
- [ ] Optional: Publish tech article
- [ ] Optional: Record walkthrough demo

---

### Environment Started:
- dev — **2025-12-06 11:52**
- dev — **2025-12-06 12:05**
