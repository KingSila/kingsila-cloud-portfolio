# Daily Log – 2025-12-03 (Wednesday)

## High-Level Summary
Focused on stabilising Azure Policy-as-Code within the Terraform platform layer. Completed the new `policy_assignment` module, fixed subscription ID formatting issues, corrected Azure Policy parameter naming, and wired the Allowed Locations guardrail into the dev environment. Terraform configuration is now valid and ready for rollout across environments.

---

## What I Worked On

### 1. Implemented Terraform Policy Assignment Module
- Built a reusable module for subscription-level Azure Policy assignments.
- Added support for enforce mode, policy definition ID, and automatic JSON encoding.
- Normalised subscription ID to the required `/subscriptions/<GUID>` format.

### 2. Connected Built-In “Allowed Locations” Policy
- Used the built-in definition: `e56962a6-4747-49cd-b67b-bf8b01975c4c`.
- Identified the required parameter name: `listOfAllowedLocations`.
- Updated Terraform to send:
  ```hcl
  parameters = {
    listOfAllowedLocations = {
      value = var.allowed_locations
    }
  }
