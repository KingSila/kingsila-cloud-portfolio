# 🧾 Daily Engineering Log — 2025-12-29
**Focus:** AKS Observability · Helm Golden Chart · Phase 1 → Phase 2
**Energy level:** Low by end of day (good call to stop)

---

## ✅ What was accomplished

### Observability — Phase 1 (Cluster)
- Enabled **Container Insights** on test AKS
- Verified Log Analytics workspace wiring
- Standardised use of `az aks command invoke` for all kubectl access
- Confirmed Azure RBAC behavior for AKS (resolved Forbidden errors via role understanding)

### Observability — Phase 2 (App groundwork)
- Created **Application Insights (test)** with tags
- Designed observability contract for Helm golden chart:
  - App Insights connection string via Secret
  - OpenTelemetry env vars (`OTEL_SERVICE_NAME`, `OTEL_RESOURCE_ATTRIBUTES`)
- Wired observability into Deployment template

### Helm Golden Chart (Major wins)
- Fixed **invalid Deployment patch** caused by misplaced `env:` block
- Corrected **Workload Identity annotation placement**
- Added **nil-safe guards** for optional values:
  - `observability` guarded with `default dict`
  - `.Values.env` handled safely
- Chart now renders cleanly with:
  ```bash
  helm template golden-app .
