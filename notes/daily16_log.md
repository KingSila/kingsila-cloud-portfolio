# 📅 Daily Log — 2025-11-26

## 🚀 Summary
Today revolved around strengthening CI/CD authentication using GitHub OIDC, cleaning up identity management, and wrestling with Azure RBAC timing quirks. We made major progress replacing static secrets with dynamic principal resolution, consolidating identity across environments, and stabilizing the destroy workflow. The only blocker left was Azure RBAC propagation inside Key Vault being slower than the Terraform apply sequence.

## 🧩 What I Worked On

### 🔐 1. GitHub OIDC → Azure Integration
- Ensured Terraform pipelines use **Azure OIDC** instead of client secrets.
- Added dynamic resolution of the Terraform Service Principal Object ID.
- Updated both *plan* and *apply* jobs to automatically inject:
  - `TF_VAR_terraform_principal_object_id`
- Cleaned up old per-environment principal ID secrets.

### 🏗️ 2. CI/CD Workflow Improvements
- Updated the **Terraform main pipeline** YAML end-to-end.
- Updated and fixed the **Terraform Destroy pipeline**, ensuring:
  - Proper OIDC login
  - Dynamic principal detection
  - Correct artifact handling
  - Environment approvals
- Removed fragile or redundant secret logic.

### 🔏 3. Key Vault Permissions Troubleshooting
- Investigated repeated `403 ForbiddenByRbac` errors.
- Confirmed the correct SP (`oid=be8514e5-2b03-4322-9810-1e7f97e7c14e`) is being used.
- Verified role assignment creation was successful.
- Root cause identified as **Azure RBAC propagation delay** inside Key Vault.
- Final error of the day:
