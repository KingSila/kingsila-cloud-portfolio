# Daily Log — 2025-12-20

## Focus
AKS dev environment reset, Terraform cleanup, and cost control. Continued Week 7 work (AKS module, private cluster networking, workload identity groundwork).

## What Was Done
- Investigated AKS private cluster connectivity issues (`kubectl` DNS resolution failures).
- Verified platform VNet and subnet layout:
  - Confirmed address space `10.20.0.0/16`
  - Reviewed AKS subnets for dev/test/prod.
- Used `az aks command invoke` to validate cluster-side health (ingress-nginx running).
- Identified private endpoint / DNS dependency as root cause of local access failures.
- Decided to **destroy and recreate dev AKS** to avoid ongoing cost leakage.
- Cleaned up Terraform outputs and wiring for:
  - AKS cluster name and ID
  - Subnet ID
  - Workload Identity client IDs
- Marked outstanding checklist items as complete where outputs were already present.
- Paused further changes intentionally to resume with a fresh mind.

## Decisions Made
- Dev AKS will be rebuilt cleanly instead of patched incrementally.
- Cost control takes priority over debugging a misaligned dev state.
- Remaining private DNS and jumpbox access work deferred to next session.

## Issues / Blockers
- Local access to private AKS API fails without proper DNS or jumpbox routing.
- Private DNS zone linkage needs to be validated post-rebuild.

## Next Steps
- Destroy dev environment completely (Terraform destroy).
- Recreate dev AKS with:
  - Correct private DNS zone linkage
  - Verified jumpbox access path
- Validate `kubectl` access from jumpbox first, then local.
- Continue Week 7 objectives: ingress, workload identity, Helm baseline.

## Notes
Stopped intentionally before fatigue-induced chaos. Infrastructure rewards patience and punishes bravado.
