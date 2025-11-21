# 2025-11-21 — Daily Log

## Summary
Focused on stabilizing Terraform workflows across local and CI environments. The main blockers involved outdated Terraform version constraints, stale remote state locks, and missing OIDC configuration for destroy pipelines. Significant progress was made clearing state locks, aligning backend access, correcting federated credentials, and updating versioning.

## Key Actions Completed
- Investigated and resolved multiple **state lock issues** in both `dev` and `test` environments.
- Identified and cleaned up stale locks created on **2025-11-16** using incorrect Terraform version `1.13.0`.
- Updated Terraform version handling to **1.9.8** for consistency across CI and local usage.
- Updated Terraform `required_version` constraints to support current stable releases.
- Added or corrected **federated identity credentials** for:
  - `destroy-dev`
  - `destroy-test`
- Validated correct OIDC subject format for GitHub Environments.
- Fixed missing provider inputs (`client_id`, `tenant_id`, `subscription_id`) required for OIDC authentication.
- Ensured ARM_* environment variables are correctly injected into GitHub Actions workflows.
- Confirmed usage of shared remote backend to prevent state drift between local and CI.

## Outstanding Items / Next Steps
- Revalidate destroy pipelines after force-unlocks and OIDC fixes.
- Confirm all GitHub Environments (`dev`, `test`, `destroy-dev`, `destroy-test`) have matching federated credentials.
- Keep Terraform version locked to **1.9.8** across environments.
- Add a one-click “force unlock” workflow for future safe state cleanup.

## Notes
Today involved deep troubleshooting with remote state, version mismatches, and federated identity wiring. The fixes applied should significantly stabilize CI-driven infra management and reduce friction moving forward.
