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
## 🏁 Current Status
### **Week 3–4: CI/CD, Environments & Stability** ✔️ Completed

Progress so far:

- ✔️ Stable multi-environment setup (dev, test, prod)
- ✔️ Remote backend using environment-bound state keys
- ✔️ Terraform modules (VNet, App Service, Key Vault, Policies)
- ✔️ GitHub Actions: plan on PR, apply on merge
- ✔️ Destroy workflow with confirmation gate
- ✔️ Environment approvals + branch protection rules

⚡ **Next:** Enable Defender for Cloud baseline & expand Policy-as-Code

---

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

---

## 🔁 Daily Environment Workflow (Local Automation)

### Start the dev environment:

```powershell
pwsh ./start-environment.ps1 -Environment dev -PlanFirst -SummaryFile TRACKER.md
