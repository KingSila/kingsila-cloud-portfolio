# Daily Log — 2025-12-24

## Focus
Prepare **test environment AKS deployment pipeline** using **GitHub Actions**, with:
- Separate AKS cluster
- Separate Kubernetes namespace
- Clear isolation from dev

## Work Done
- Reviewed current repository state and identified pipeline scope for test environment
- Clarified that **test = separate AKS cluster + namespace**, not just another overlay
- Re-established baseline after prior environment teardown (fresh start mindset engaged)
- Validated that GitHub Actions will be the deployment mechanism (not local kubectl)

## Decisions
- Test environment will mirror dev structure but remain fully isolated
- CI/CD responsibilities belong to GitHub Actions only
- Cluster lifecycle and workload deployment will be treated as separate concerns

## Open Items / Next Steps
- Define GitHub Actions workflow structure for test AKS
- Confirm authentication method (OIDC / Service Principal)
- Create test-specific Kubernetes manifests or overlays
- Decide whether ingress is required for test or deferred
- Ensure cost controls before cluster creation

## Notes
- Fresh environment, clean slate, fewer ghosts
- Today was about alignment and intent, not brute-force YAML
