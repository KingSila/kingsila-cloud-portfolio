# 🗓️ Daily Log — 2025-12-10

## 🚀 Work Done
- Reviewed Terraform pipeline issues and generated multiple commit messages for policy + tfsec fixes.
- Parked several “energy-draining” tasks into the project fridge for later defrosting.
- Cleaned up Azure Policy assignment logic and validated module patterns.
- Generated TF destroy pipeline YAML and updated environment-specific backend usage.
- Inspected App Service + Application Insights behaviour; confirmed telemetry and logs flowing.
- Discussed tfvars, allowed_locations, and wiring through env modules.
- Produced documentation snippets for secrets workflow, policy descriptions, and infra layout.
- Continued organising the repo into workflow-ready structure (actions, tfsec, environments).
- Debugged subscription-level policy assignment errors (missing parameters, incorrect JSON structure).

## 🧩 Issues Encountered
- Azure Defender contact error caused by duplicate email assignment.
- tfsec CLI / Checkov path confusions in runner environment.
- Terraform unable to read modules due to incorrect module directory references.
- Missing `environment`, `allowed_locations` and `tags` when running destroy workflow.
- Portal showing no logs initially, later confirmed telemetry shaping properly.
- Policy assignment parameter mismatch (`listOfAllowedLocations` vs custom key).

## 🛠️ Fixes & Decisions
- Updated policy parameters to match built-in definitions.
- Adopted one-tfstate-per-env pattern using backend override approach.
- Confirmed secret flow: GitHub → pipeline → Key Vault → App settings.
- Generated documentation tasks and scheduled them mentally for fridge storage.
- Standardised Git Bash syntax for all Terraform + Azure CLI usage.

## 📦 Items Sent to the Fridge
- Full Azure Policy rollout for test and prod.
- Expanded tfsec hard-fail logic for CI gatekeeping.
- TF env destroy script rewrite (PowerShell alternative still pending).
- Documentation consolidation across security, infra, and CI/CD.

## 🧠 Notes for Future You
- Revisit policy definitions and create reusable patterns across all environments.
- Expand secret-management doc with visuals once energy levels are replenished.
- Fix remaining pipeline UX quirks around variable passing and environment detection.
- Keep an eye on App Insights sampling settings—logs sometimes hide behind the couch.

## 🎯 Overall Mood
Terraform behaved like a moody wizard, Azure Policies acted like bureaucracy incarnate,
but progress marched onward. Today was productive, slightly chaotic, and sprinkled with triumph.
