# KingSila Cloud Portfolio – Project Status

- **Project:** KingSila Cloud Portfolio
- **Timeline:** 07 Nov 2025 → 30 Jan 2026
- **Total Duration:** 12 weeks
- **Overall Progress:** **35%**

---

## 📆 Weekly Progress Overview

### ✅ Weeks 1–2 – Azure Core + Terraform Foundations
**Status:** Completed (100%)
**Hours spent:** 12

**Highlights:**
- Created initial project structure
- Fixed Terraform module duplication errors
- Set up Service Principal for Terraform
- Built reusable modules:
  - VNet
  - NSG
  - Route tables
- Configured remote state backend in Azure Storage
- Bootstrapped backend infrastructure
- Implemented provider inheritance best practices
- Deployed **dev environment** with VNet
- Added **App Service with VNet integration**
- Implemented monitoring:
  - Log Analytics
  - Application Insights
- Fixed Git/GitHub issues (large files, credentials)
- Created comprehensive **dev environment README**
- Committed daily logs for early project days

---

### ✅ Weeks 3–4 – RBAC, Environments & CI/CD
**Status:** Completed (100%)
**Hours spent:** 7

**Highlights:**
- Set up **directory-based environments** for dev and test
- Configured **separate remote state keys** per environment (dev/test)
- Implemented **GitHub Actions workflow** for Terraform plan/apply (matrix for envs)
- Added **artifact-based** plan/apply split (`tfplan-dev`, `tfplan-test`)
- Implemented **safe RG import automation** in CI (only when missing from state)
- Enabled **Key Vault RBAC mode** and aligned Terraform config
- Granted Terraform CI service principal **Key Vault Secrets Officer** role
- Wired Terraform CI to use the **correct SP object ID** for Key Vault access
- Successfully completed **Terraform apply for dev env from CI**, including Key Vault secrets

---

### 🛡️ Weeks 5–6 – Security, Monitoring & Secrets Management
**Status:** In progress (35%)
**Hours spent:** 0 (tracked in JSON as planning / conceptual work so far)

**Completed so far:**
- Enabled **Defender for Cloud baseline** at subscription level
- Created initial Terraform module for **Azure Policy assignments** (allowed locations)

**Still to do:**
- Centralise **Azure Key Vault + workload identities** (OIDC / Managed Identity)
  *(you’ve actually made big strides here already in our recent work)*
- Harden and expand **policy assignments** via Terraform
- Implement **cost budgets** and solid **tagging strategy**
- Add Terraform validation + **security scanning** (checkov / tfsec)
- Document **security architecture**

---

### ⏭️ Weeks 7–8 – Advanced CI/CD & Testing
**Status:** Not started (0%)

**Planned work:**
- Build full GitHub Actions pipeline:
  - plan
  - apply
  - destroy
- Add **approval gates** and **environment protection** rules
- Implement **Terraform testing** (e.g. terratest)
- Add **drift detection automation**
- Create **rollback procedures**
- Update `/docs/devops.md` with pipeline documentation

---

### ☸️ Weeks 9–10 – Containers & Kubernetes
**Status:** Not started (0%)

**Planned work:**
- Create **AKS cluster module** with best practices
- Set up **Azure Container Registry (ACR)**
- Deploy **sample containerised app** via Helm
- Integrate AKS with existing VNet (spoke pattern)
- Add AKS monitoring + logging
- Document AKS architecture with diagrams

---

### 🎨 Weeks 11–12 – Portfolio Polish & Career Prep
**Status:** Not started (0%)

**Planned work:**
- Create **hub-and-spoke architecture diagram**
- Finalise end-to-end **project documentation**
- Polish main **README** with architecture overview
- Add **CI/CD pipeline diagrams**
- Update **CV** with concrete Azure/Terraform achievements
- Publish a **technical blog post** (Medium / LinkedIn / Dev.to)
- Prepare **interview talking points** from project experience
- (Optional) Record a **demo video**

---

## 📔 Daily Log Snapshot (2025-11-24)

- **Week:** 3–4
- **Hours spent:** 2

**Tasks completed:**
- Debugged **403 Forbidden** errors from Azure Key Vault during Terraform apply in CI
- Confirmed and implemented **Key Vault RBAC mode** with updated provider attributes
- Configured Terraform module to assign **Key Vault Secrets Officer** role to the CI SP
- Verified **successful Terraform apply** for dev (including secret creation from GitHub Actions)

**Challenges:**
- Differentiating between:
  - management-plane RBAC roles
  - data-plane Key Vault secret permissions
- Navigating deprecated vs new flags:
  - `enable_rbac_authorization`
  - `rbac_authorization_enabled`
- Ensuring the **correct service principal object ID** was used (not appId)
- Interpreting Azure’s 403 messages to pinpoint **missing data-plane permissions**

**Key learnings:**
- Key Vault data-plane access requires specific **secret roles** (e.g. Secrets Officer), not just generic RBAC like User Access Administrator
- RBAC mode must be explicitly enabled on Key Vault for RBAC assignments to work for secrets
- Consistent use of the **SP object ID** across Terraform and CI avoids RBAC mismatches
- A **green Terraform apply from CI** is the best proof that identity, RBAC, and state wiring are correct

**Notes:**
> Focused on fixing Key Vault access for Terraform in GitHub Actions.
> After enabling RBAC mode, assigning a proper data-plane role to the CI SP, and wiring the correct object ID into Terraform, dev applies now run successfully with secrets managed in Key Vault. This solidifies the RBAC + CI foundation to reuse for test and prod.

---

## 🧠 Skills Snapshot

### Azure

- **VNet:** intermediate
- **App Service:** intermediate
- **AKS:** beginner
- **Monitoring:** intermediate
- **Security:** beginner (but clearly levelling up fast)
- **Log Analytics:** intermediate

### Terraform

- **Modules:** intermediate
- **State management:** intermediate
- **Best practices:** intermediate
- **Backend bootstrap:** intermediate

### DevOps

- **GitHub Actions:** beginner
- **Azure DevOps:** beginner
- **CI/CD (general):** beginner
- **Git:** intermediate

---

## 🎓 Certifications

**Target:**

- AZ-104 – Azure Administrator
- AZ-305 – Azure Solutions Architect
- Terraform Associate

**Completed:**
- None yet (but the project work is absolutely in that territory)

---

## 🏅 Project Badges / Meta Progress

- **Weekly streak:** 1
- **Modules created:** 3
- **Pipelines built:** 1
- **Issues resolved:** 9
- **Weeks fully completed:** 2

---

## 🚦 Current Focus

You are currently in **Weeks 5–6: Security, Monitoring & Secrets Management** with **35% progress**.

The next big pushes that move the needle:

- Fully **centralise Key Vault + managed identities** (which you’ve basically just done with the platform/dev/test/prod refactor).
- Add **policy + budget + tagging** guardrails.
- Introduce **tfsec / checkov** into CI to harden infra.

This JSON you dropped is basically your **project control panel** — we can keep updating this Markdown view as you move through weeks 5–12.
