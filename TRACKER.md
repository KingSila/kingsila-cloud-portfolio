# 12-Week Platform Engineering Tracker
**Azure · Terraform · GitHub Actions · AKS · SRE**

---

## ✅ Weeks 1–2: Platform CI/CD & IaC Foundations (COMPLETED)

- [x] Standardised GitHub Actions workflow for Terraform
- [x] Implemented OIDC authentication with Azure
- [x] Created reusable CI pipeline templates
- [x] Fixed artifact upload & naming issues
- [x] Set up GitHub Environments (dev/test/prod/destroy)
- [x] Added branch protection for `main`
- [x] Enabled pre-commit (fmt, validate, tflint, markdown lint)
- [x] Added environment lifecycle scripts + VS Code tasks
- [x] Documented CI/CD (`/docs/cicd.md`)
- [x] Added drift detection scaffolding

---

## ✅ Weeks 3–4: IaC Governance & Multi-Env Foundations (COMPLETED)

- [x] Refactored Terraform environments with stable backend keys
- [x] Fixed `for_each` list/map issues
- [x] Integrated remote state for dev/test/prod
- [x] Created reusable network/resource modules
- [x] Added destroy protections + approval workflow
- [x] Introduced tagging & cost governance groundwork
- [x] Added management groups + RBAC scaffolding
- [x] Solved state/drift issues across environments
- [x] Finalised Platform Environment Lifecycle workflow

---

## Weeks 5–6: Security, Compliance & Platform Guardrails

- [~] Finalise Azure Policy as Code (allowed locations/SKU/naming)
- [ ] Create policy-assignment Terraform module
- [ ] Enable Defender for Cloud baseline
- [ ] Centralise Key Vault + workload identities (OIDC / MI)
- [ ] Add tfsec / checkov scanning to CI
- [ ] Document security architecture (`/docs/security.md`)

---

## Weeks 7–8: App Platform Layer — AKS & Deployment Standards

- [ ] Create AKS Terraform module (node pools, identity, logging)
- [ ] Deploy AKS to dev + integrate with existing VNet
- [ ] Build base Helm chart template (golden chart)
- [ ] Build GitHub Actions pipeline for app → AKS deployment
- [ ] Implement ingress, certs & workload identity
- [ ] Document golden deployment pattern (`/docs/platform-runtime.md`)

---

## Weeks 9–10: Observability, SRE & Platform Reliability

- [ ] Add metrics/logs/tracing for AKS + apps
- [ ] Create platform dashboards (Grafana / App Insights / Log Analytics)
- [ ] Implement HPA + probes + PDBs
- [ ] Add alert rules (cluster + deployments)
- [ ] Define simple SLOs
- [ ] Document reliability standards (`/docs/sre.md`)

---

## Weeks 11–12: Platform Packaging & Career Positioning

- [ ] Create architecture diagrams (Hub-Spoke + AKS + CI/CD)
- [ ] Write Platform Overview in README
- [ ] Prepare 10-minute internal presentation
- [ ] Draft promotion narrative
- [ ] Update CV with platform achievements
- [ ] Optional: Publish tech article
- [ ] Optional: Record walkthrough demo
