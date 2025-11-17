# Day Log - November 17, 2025

## 🎯 Today's Focus
- Stabilise Terraform GitHub Actions workflow (plan/apply)
- Fix tfplan artifact upload/download flow
- Make Terraform state + RG handling safe and CI-friendly

---

## ✅ Completed Tasks

- Cleaned up Terraform CI/CD workflow YAML:
  - Fixed indentation so `Terraform Plan` and `Upload Plan Artifacts` run as proper steps
  - Standardised artifact naming to `tfplan-${environment}` for dev/test
  - Ensured `terraform-apply` job correctly depends on `terraform-plan` and uses matching artifact names
- Improved remote state and environment separation:
  - Confirmed dev/test backends use separate keys (`dev` vs `test` state)
  - Verified Terraform state alignment for `rg-kingsila-dev` and `rg-kingsila-test`
- Hardened CI logic around existing resource groups:
  - Added safe “import RG if needed” step that:
    - Skips if RG doesn’t exist in Azure
    - Detects whether `azurerm_resource_group.rg` is in root or module
    - Imports only when RG exists in Azure but is missing from state
    - Stops re-importing when already tracked in state
- Removed unnecessary complexity:
  - Simplified use of commit SHA where not needed
  - Reduced over-defensive import logic that was failing the pipeline despite healthy state

---

## 🧠 Challenges

- GitHub Actions YAML indentation caused key Terraform steps (plan + artifact upload) to run **inside** a shell script instead of as distinct steps, which meant:
  - No `tfplan` artifact uploaded
  - Apply job failing with:  
    `Artifact not found for name: tfplan-dev`
- Mixed history of Terraform state + manual imports caused confusing messages like:
  - `State has azurerm_resource_group.rg but points to a different RG`
  even though dev/test RGs were actually correct when inspected locally.

---

## 📚 Learnings

- In GitHub Actions, **indentation = life**:
  - `- name:` must align as a sibling step, never inside a `run: |` block.
- Terraform imports should be treated as **one-time surgery**, not something you repeat in CI:
  - CI should only import when a resource exists in Azure but is missing from state.
- Using stable artifact names (`tfplan-dev`, `tfplan-test`) is simpler and less error-prone than mixing in commit SHAs unless you really need that complexity.
- Separate backend keys per environment + clear folder structure makes reasoning about state much easier:
  - Code + state + Azure resources all line up cleanly.

---

## ⏱ Hours Spent

- Approximate time: **3 hours**

---

## 🧩 Next Steps

- Add/verify branch protection + environment-based approvals for `terraform-apply` to test/prod.
- Start ticking off RBAC / environment tasks from the Week 3–4 plan:
  - Management Groups / RBAC policies
  - Test/prod environment structure formalised in Terraform
- Later: add security scanning (checkov/tfsec) hooks around the pipeline.
