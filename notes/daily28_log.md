# Daily Log – 2025-12-09 (Tuesday)

## High-Level Summary
Focused on strengthening platform governance and Terraform code structure. Added subscription-level tag enforcement policies and cleaned up the main Terraform configuration for clarity and maintainability. Security and policy guardrails continue to take shape, setting the stage for closing out Weeks 5–6.

---

## What I Worked On

### 1. Added Azure Tag Enforcement Policies
- Implemented built-in Azure Policy assignments:
  - **Require owner tag**
  - **Require environment tag**
- Looked up and validated the correct policyDefinitionIds.
- Integrated both policies cleanly using the existing `policy_assignment` module.
- Confirmed these should live in root `infra/main.tf` as subscription-level guardrails.

### 2. Cleaned and Refactored `main.tf`
- Removed unused data sources.
- Reorganised file into clean logical blocks:
  - Identity
  - Policy
  - Resource Group + Network
  - Key Vault
  - App Service
  - Defender
- Ensured naming consistency and simplified comments.
- Avoided any Terraform state changes by keeping names/values identical.

### 3. Checkov + tfsec Pipeline Fixes
- Investigated GitHub SARIF errors.
- Updated Checkov command:
  - Removed incorrect `>` redirect.
  - Replaced with `--output-file-path`.
- Learned portal-side names of tag policies for easier lookup and validation.

### 4. Updated Platform Roadmap & Week 5–6 Alignment
- Re-aligned 12-week roadmap with actual progress (60% overall).
- Confirmed remaining Week 5–6 tasks:
  - Deny public endpoints
  - Naming policies
  - `/docs/security.md`
  - (Parked in the fridge for now.)

---

## Challenges
- Azure Policy documentation and portal naming inconsistencies required manual verification.
- Checkov SARIF generation was invalid until switching to official output-file approach.
- Ensuring subscription-level governance didn’t conflict with environment-level Terraform states.

---

## Key Learnings
- Azure’s built-in tag policies share a common definition but require distinct assignments per tag name.
- SARIF upload flows must avoid stdout redirects — always use native exporter flags.
- Terraform policy modules become much clearer when refactoring around subscription vs environment scope.
- Tidying `main.tf` early prevents productivity decay later.

---

## Notes
> Governance guardrails are starting to take shape. With tag enforcement live and main.tf stable, the next iteration on security policy (deny public access + naming standards) will be quick to pick up again after the fridge break.

---
