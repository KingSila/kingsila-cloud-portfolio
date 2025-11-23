# Daily DevOps Log – 23 Nov 2025

## What I worked on
- Reviewed and iterated on **Terraform CI/CD GitHub Actions workflow**:
  - Verified trigger configuration for:
    - `pull_request` on `main` for `infra/**` and workflow file changes
    - `push` on `main` for `infra/**` and workflow file changes
    - `workflow_dispatch` with `environment` input (`dev`, `test`, `prod`)
  - Confirmed environment variables for:
    - `TERRAFORM_VERSION`
    - `TF_IN_AUTOMATION`, `TF_INPUT`, `TF_PLUGIN_CACHE_DIR`
    - Azure OIDC auth: `ARM_CLIENT_ID`, `ARM_TENANT_ID`, `ARM_SUBSCRIPTION_ID`
  - Ensured correct placement of the workflow file:
    - `.github/workflows/terraform-ci.yml`

## Decisions & notes
- Standardized on **GitHub Actions** for Terraform CI/CD entrypoint:
  - File lives in: `.github/workflows/terraform-ci.yml`
  - Pipeline will be the central point for `terraform plan` / `apply` per environment.
- `permissions` block configured for:
  - `contents: read`
  - `pull-requests: write`
  - `id-token: write` (for Azure federated identity)

## Blockers / To sort out later
- Need to:
  - Finish defining the `terraform-plan` job:
    - Checkout code
    - Set up Terraform
    - Log in to Azure via OIDC
    - Run `terraform init`, `plan` (and later `apply`) against `infra/` directory.
  - Decide how to:
    - Map `workflow_dispatch.inputs.environment` → `TF_VAR_environment` or backend workspace.
    - Handle separate state files / workspaces per environment.

## Next session plan
- Complete the `terraform-plan` job with full steps:
  - `actions/checkout`
  - `hashicorp/setup-terraform`
  - `azure/login` (using OIDC)
  - `terraform init` + `terraform plan` for target environment.
- Add a second job for **`terraform-apply`**:
  - Triggered only:
    - On `main` merge, or
    - Via `workflow_dispatch` with manual confirmation (e.g., using environments / approvals).
- Add basic CI checks:
  - `terraform fmt -check`
  - `terraform validate`

---

🧠 Energy level: Officially depleted. CI/CD brain will reboot next session.
