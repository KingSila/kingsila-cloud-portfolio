# Daily Log – 2025-12-07 (Sunday)

## High-Level Summary
Worked through Terraform deployment issues across environments, focusing especially on RBAC errors, Key Vault access, and role assignment mismatches. Dev and test environments are now stable, prod is nearly ready, and the stack is behaving more predictably. CI/CD pipelines are being refined, and the overall platform is approaching “grown-up cloud” status.

---

## What Happened Today

### 1. Diagnosed Role Assignment Failure
- Terraform attempted to create a role assignment using a **Service Principal** principal type.
- Azure responded with a charming “nope,” saying the principal ID was actually a **User**, not a Service Principal.
- Fix required aligning `principal_type` correctly before role assignment runs.

### 2. Key Vault 403 (Forbidden) Adventures
- Attempts to read or write secrets failed with RBAC propagation delays or missing permissions.
- Confirmed the GitHub OIDC identity did not yet have the required Key Vault roles.
- Once the correct `Key Vault Secrets Officer`/Reader roles propagated, the pipeline resumed behaving normally.

### 3. Secret Flow Clarified
- GitHub Secrets → Pipeline → Key Vault → App Services.
- No secrets in Terraform state.
- The circle of life, but for credentials.

### 4. Terraform Module Polish
- Cleaned up policy-assignment module.
- Ensured `parameters` block uses correct `jsonencode` format for 4.x provider.
- Updated module inputs to avoid type mismatches and linted structure.

### 5. CI/CD State & Backend Validation
- Verified remote backend storage is isolated per environment.
- Ensured `key = "${var.environment}/terraform.tfstate"` matches expectations.
- Confirmed dev/test are using separate state keys and are no longer clobbering each other.

---

## Current Environment Status

- **dev** — Plan & Apply working. Secrets flowing. Stable.
- **test** — Plan & Apply working. Key Vault permissions corrected. Stable.
- **prod** — Deploying next; nearly ready after earlier module fixes.

---

## What’s Next

1. Finalize and test **prod** deployment.
2. Implement **Defender for Cloud baseline**.
3. Add **tfsec/checkov** scanning to CI.
4. Build out security architecture docs (`/docs/security.md`).
5. Wrap policy assignments into a clean reusable module.

---

## Notes for Future You
Azure RBAC propagation delays are the cloud equivalent of a vending machine that accepts your coin and then stares at you in silence for 5 minutes.

Terraform is doing fine. You’re doing fine. The caffeine is doing most of the heavy lifting.
