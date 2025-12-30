# Daily Log – 2025-12-08 (Monday)

## High-Level Summary
Most of today revolved around strengthening the governance layer of the Terraform setup.
You successfully introduced **static security scanning** via tfsec in GitHub Actions, fixed module wiring issues, deployed **policy definitions + assignments** across **dev, test, and prod**, and got actionable feedback from tfsec on Key Vault hardening.
A good blend of infra building, governance tuning, and pipeline evolution.

---

## What Was Completed Today

### 1. Policy Definition & Assignment Working Across All Environments
- Fixed the `allowed_locations` module wiring.
- Corrected `policy_category` usage using Azure `metadata`.
- Deployed working **allowed-locations** policy definitions + assignments to **dev**, then **test**, then **prod**.
- Verified deployment in Azure Portal (Definitions + Assignments).
- Confirmed policies enforce correct region restrictions.

### 2. Subscription ID Handling Cleanup
- Removed the need to store subscription IDs in tfvars by pulling dynamically from:
  `data.azurerm_client_config.current.subscription_id`
- Verified root modules and assignment modules correctly accept this value.

### 3. Added tfsec Security Scanning to GitHub Actions
- Implemented a fully working `.github/workflows/terraform-security.yml`.
- Workflow runs on every PR touching `infra/`.
- First step: non-blocking tfsec scan → shows all findings.
- Second step: blocking tfsec CLI scan → fails only on HIGH/CRITICAL issues.
- Resolved errors from invalid action inputs and fixed the pipeline using a stable CLI-based enforcement strategy.

### 4. tfsec Findings Investigation
- Identified a **CRITICAL** alert: Key Vault missing `network_acls`.
- Designed a fix for your Key Vault module with:
  - `default_action = "Deny"`
  - `bypass = "AzureServices"`
  - Optional ip_rules + subnet allowlists
- Fix parked for later (energy-friendly deferral).

---

## Pending / Parked for Later
- Apply Key Vault network ACL hardening to silence tfsec CRITICAL warning.
- Add Checkov or SARIF reporting (optional enhancements).
- Extend `docs/security.md` with:
  - Policy governance overview
  - tfsec flow and expectations
  - ACL requirements for platform Key Vault

---

## Overall Notes
Today you added a security perimeter around the entire Terraform workflow—runtime policy via Azure and pre-merge scanning via tfsec.
All environments now share consistent governance, the pipeline gained a security gatekeeper, and the codebase evolved toward stricter, safer defaults.

A strong day of platform hardening, even with tfsec snitching on your Key Vault.

---
