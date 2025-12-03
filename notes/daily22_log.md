# Daily Log – 2025-12-03 (Wednesday)

## High-Level Summary
Stabilised all Terraform environments and moved forward with platform governance planning. Confirmed correct Azure Policy assignment resources, aligned dev/test/prod patterns, and clarified Terraform destroy workflow for safe cleanup.

## What I Worked On

### 1. Multi-environment Terraform stability
- Verified **dev** and **test** both run clean `terraform validate` and `terraform plan`.
- Ensured **prod** environment is being set up using the same patterns as dev/test.
- Finalised use of `environment` values inside backend keys to isolate remote state per environment.

### 2. Terraform destruction workflow
- Documented the proper way to run `terraform destroy` for any environment.
- Ensured process includes re-running `terraform init` with correct backend config before destroying infra.
- Standardised destroy commands:
  - `terraform destroy -var-file="env/dev.tfvars"`
  - `terraform destroy -var-file="env/test.tfvars"`
  - `terraform destroy -var-file="env/prod.tfvars"`

### 3. Azure Policy assignment correctness
- Confirmed older Azure Policy assignment resources are **deprecated/removed** in current provider versions.
- Standardised on the newer resource:
  - **azurerm_resource_policy_assignment**
- This supports assignment at subscription, RG, MG, or resource-level via the `scope` parameter.

### 4. Next-phase platform governance roadmap
- Build reusable **policy-assignment module**.
- Enable **Defender for Cloud** baseline.
- Centralise **Key Vault + workload identities** (Managed Identity + OIDC).
- Add **tfsec** and **Checkov** scanning to CI/CD.
- Begin `/docs/security.md` to document platform identity, secrets, guardrails, and CI/CD security posture.

## Current Status
- dev → stable
- test → stable
- prod → being brought online
- Governance module work ready to begin next.

## Commit Message Suggestion
