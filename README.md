# KingSila Cloud Portfolio – Azure | Terraform | DevOps

Welcome 👋
This repository documents my journey from experienced engineer to
**Senior Cloud Engineer (Azure / Terraform / DevOps)** — targeting Hybrid or fully remote roles in **SA**, **US** and **Europe**.

---

## 🚀 Purpose

- Build **production-grade Azure infrastructure** using modern DevOps patterns.
- Create **reusable, enterprise-ready Terraform modules**.
- Implement **secure CI/CD automation** with GitHub Actions.
- Showcase real-world cloud architecture, security, and observability skills.
- Track continuous learning and hands-on progress.

---

## 📆 Timeline

**November 2025 → January 2026**
12-week structured roadmap focused on:

1. Azure core infrastructure & governance
2. Terraform advanced modules
3. CI/CD and automation
4. Security, monitoring, and cost optimisation
5. Containers & AKS
6. Final portfolio build + interview preparation

See [`TRACKER.md`](./TRACKER.md) for weekly milestones.

---

## 🧱 Project Structure

```text
infra/                   → Terraform root, modules, and environments
  ├── modules/           → Reusable Terraform modules
  ├── envs/              → Environment configs (dev/test/prod)
  └── backend/           → Remote state configuration
.github/
  └── workflows/         → CI/CD pipelines (plan/apply/destroy)
docs/                    → Architecture, security & CI/CD documentation
notes/                   → Daily logs & learning notes
pipelines/               → Additional automation and pipeline scripts
```

## 🧰 Tooling

| Area | Tools |
|------|--------|
| Cloud | Azure, Azure CLI |
| IaC | Terraform, AzureRM Provider |
| Automation | GitHub Actions |
| Security | Azure Policy, Defender for Cloud, Key Vault |
| Observability | Azure Monitor, Log Analytics |
| Version Control | Git, GitHub |
---
## 🧩 Featured Portfolio Project
### **End-to-End Azure Cloud Platform with Terraform & GitHub Actions**
Includes:

- Hub-and-Spoke network foundation
- Environment-isolated deployments (dev/test/prod)
- Managed Identity + Key Vault integration
- Automated CI/CD with OIDC authentication
- Azure Policy guardrails and baseline security
- Monitoring, diagnostics, and cost controls

This project demonstrates cloud engineering at scale, built for real production patterns.

---

# 📊 Overall Progress

**Current Progress: ~87–88%**

### Breakdown
- **Weeks 1–4:** 100% — Foundations complete
- **Weeks 5–6:** 100% — CI/CD & environment stability
- **Weeks 7–8:** 100% — AKS, Helm & runtime validation
- **Weeks 9–12:** Planned — hardening, SRE & production narrative

---

# 📌 Snapshot Summary

## ✔ Completed to Date

- End-to-end Terraform CI/CD with GitHub Actions (OIDC-based auth)
- Multi-environment Azure architecture (dev / test / prod)
- Remote state isolation and backend governance
- Azure identity patterns with Managed Identity + Key Vault
- Policy-as-Code and baseline security guardrails
- Governance controls aligned with production practices
- **Private AKS platform fully deployed and validated**
- **Ingress and NetworkPolicy resolved under real-world constraints**
- **Helm Golden Chart implemented for standardised application delivery**
- **Runtime standards documented and enforced across environments**

This phase validates not just deployment success, but **operational correctness**.

---

## 🚀 In Progress

- Observability design (logs, metrics, traces)
- Application Insights and Azure Monitor integration patterns
- SRE principles applied to the platform (signals, ownership, runbooks)

---

## 🔜 Coming Next

- TLS enablement and certificate lifecycle management (cert-manager)
- Alerting strategy and signal-to-noise tuning
- SRE documentation (SLIs, SLOs, error budgets)
- Production-readiness narrative and platform case study

---

## 🧠 Status Summary

The platform has moved beyond “infrastructure works”
into **“infrastructure behaves correctly under constraints.”**

Remaining work focuses on **resilience, visibility, and operational maturity** rather than core build-out.


## 🚀 Quick Start

### Prerequisites

- Azure CLI installed + authenticated
- Terraform **>= 1.9.8**
- GitHub repo configured with OIDC secrets:
  - `AZURE_CLIENT_ID`
  - `AZURE_TENANT_ID`
  - `AZURE_SUBSCRIPTION_ID`

---

## 🏗️ CI/CD Workflow
### Deploying with GitHub Actions

1. Create a feature branch
2. Push → GitHub Actions runs **Terraform Plan**
3. Open a PR → reviewers see the plan diff
4. Merge to `main` → pipeline **applies** to environment
5. Optional teardown via `workflow_dispatch`

This workflow ensures:

- Zero local credentials
- Reproducible deployments
- Full audit trail
- Safe, controlled promotion between environments

## CI Status

### Terraform Pipeline

[![Terraform CI/CD](https://github.com/KingSila/kingsila-cloud-portfolio/actions/workflows/terraform-ci.yml/badge.svg)](https://github.com/KingSila/kingsila-cloud-portfolio/actions/workflows/terraform-ci.yml)

### Environment Status

| Environment | Status Badge |
|------------|--------------|
| **Dev**    | ![Dev Status](https://github.com/KingSila/kingsila-cloud-portfolio/actions/workflows/terraform-ci.yml/badge.svg?branch=main&env=dev) |
| **Test**   | ![Test Status](https://github.com/KingSila/kingsila-cloud-portfolio/actions/workflows/terraform-ci.yml/badge.svg?branch=main&env=test) |
| **Prod**   | ![Prod Status](https://github.com/KingSila/kingsila-cloud-portfolio/actions/workflows/terraform-ci.yml/badge.svg?branch=main&env=prod) |
