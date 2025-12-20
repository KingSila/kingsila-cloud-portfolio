# Daily Log — 2025-12-19

## Focus
AKS (Dev) troubleshooting, Terraform cleanup, cost-awareness reset, and setting up a clean slate for next iteration.

## What Was Done
- Verified AKS dev cluster state and confirmed ingress-nginx controller is running.
- Used `az aks command invoke` to validate cluster access paths from Azure side.
- Investigated repeated `kubectl` failures related to private AKS API DNS resolution.
- Identified that the AKS cluster is private and DNS resolution is failing locally (expected without proper private DNS/VNet access).
- Reviewed Terraform outputs to ensure required AKS and resource group values are exposed.
- Confirmed outputs added for:
  - AKS cluster name
  - Resource group name
  - Subnet ID
  - Workload Identity client ID
- Observed Terraform destroy operations hanging due to policy assignments and managed identities.
- Acknowledged high AKS cost footprint for dev and decided **not** to continue patching live state.

## Decisions Made
- Stop troubleshooting late in the day to avoid rushed mistakes.
- Plan a **full dev environment teardown and rebuild** instead of incremental fixes.
- Prioritize cost control by destroying the dev AKS environment.
- Resume with a fresh mind and clean infra the next morning.

## Issues / Blockers
- `kubectl` cannot resolve private AKS API endpoint DNS from local machine.
- Terraform destroy slowed by policy assignments still detaching.
- Private DNS zone creation previously blocked by Azure Policy.
- Dev AKS environment complexity outweighs value of continuing to patch.

## Lessons / Notes
- Private AKS + local access always requires DNS and network planning upfront.
- Azure Policy + AKS private clusters can fail in non-obvious ways.
- Sometimes the most senior move is to nuke dev and start clean.

## Plan for Next Session
- Destroy dev environment completely.
- Recreate dev AKS with:
  - Clear private DNS strategy
  - Validated policy exclusions
  - Cost-aware sizing
- Continue AKS setup: workload identity, ingress, Helm baseline.

## Mood
Productive but intentionally paused. Discipline over heroics.
