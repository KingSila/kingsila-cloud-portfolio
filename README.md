# KingSila Cloud Portfolio – Azure | Terraform | DevOps

Welcome 👋
This repository documents my journey from experienced engineer to
**Senior Cloud Engineer (Azure / Terraform / DevOps)** — targeting fully remote roles in the **US** and **Europe**.

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

infra/ → Terraform root, modules, and envs
├── modules/ → Reusable infrastructure modules
├── envs/ → Environment configs (dev/test/prod)
└── backend/ → Remote state configuration
.github/
└── workflows/ → CI/CD pipelines for plan/apply/destroy
docs/ → Architecture, security & CI/CD docs
notes/ → Daily logs & learning notes
pipelines/ → Additional scripts & tooling


---

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
- ✔️ Remote backend using environment-based state keys
- ✔️ Terraform modules for VNet, App Service, Key Vault, policies
- ✔️ CI/CD pipeline (plan on PR, deploy on merge)
- ✔️ Destroy workflow with safety confirmation
- ✔️ Environment approvals + branch protection
- ⚡ Next: Enable **Defender for Cloud baseline** & expand Policy-as-Code

---

## 🚀 Quick Start

### Prerequisites

- Azure CLI installed + logged in
- Terraform **>= 1.9.8**
- GitHub repository with OIDC secrets configured
  (`AZURE_CLIENT_ID`, `AZURE_TENANT_ID`, `AZURE_SUBSCRIPTION_ID`)

---

## 🏗️ CI/CD Workflow

### Deploying via GitHub Actions

1. Create feature branch
2. Push → Terraform Plan runs
3. Open PR → reviewers see plan
4. Merge to main → auto apply to environment
5. Optional destroy via workflow_dispatch

This ensures **zero local credentials**, full auditability, and safe deployments.

---

## 🔁 Daily Environment Workflow (Local Automation)

Start dev environment:

```powershell
pwsh ./start-environment.ps1 -Environment dev -PlanFirst -SummaryFile TRACKER.md
