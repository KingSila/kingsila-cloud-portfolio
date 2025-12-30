# Daily Log — 2025-12-22

## Focus
Dev AKS environment setup and untangling Azure RBAC + private cluster access issues.

## What I Worked On
- Continued rebuilding the **dev AKS environment** as part of the cloud-native project.
- Applied Kubernetes manifests for:
  - Namespace (`dev`)
  - ServiceAccount (`app-sa`)
  - Deployment and related resources
- Investigated repeated **RBAC `Forbidden` errors** when applying Kubernetes resources.
- Debugged access failures tied to:
  - Azure RBAC vs Kubernetes RBAC boundary
  - Missing permissions on namespaces and serviceaccounts
- Used `az aks command invoke` to bypass local access while troubleshooting private cluster connectivity.
- Checked cluster reachability issues caused by **private DNS resolution failures** from the corporate network.
- Validated ingress controller status (`ingress-nginx`) to ensure baseline components are healthy.

## Issues Encountered
- Azure RBAC blocking Kubernetes actions:
  - `cannot get resource "namespaces"`
  - `cannot get resource "serviceaccounts"`
- Private AKS API endpoint not resolvable locally:
  - `no such host` errors against `privatelink.*.azmk8s.io`
- Required role assignments not yet aligned with workload needs.

## Decisions Made
- Avoid spending the entire day deep-diving private DNS rabbit holes.
- Prioritize **RBAC correctness** first before reattempting full manifest application.
- Accept short-lived dev cluster costs to maintain momentum rather than context-switch endlessly.

## Next Steps
- Assign correct Azure roles (likely `Azure Kubernetes Service RBAC Writer/Admin`) to unblock namespace-level operations.
- Re-validate access using `kubectl auth can-i` once roles propagate.
- Finish dev Kubernetes baseline:
  - Namespace
  - ServiceAccount
  - Deployment
  - Ingress
- Document RBAC learnings to avoid future déjà vu.

## Reflection
Progress was slower than desired, but the fog is lifting. RBAC is a harsh but honest teacher—once permissions are right, everything suddenly behaves. Today was about clearing the path so tomorrow can actually build something useful.
