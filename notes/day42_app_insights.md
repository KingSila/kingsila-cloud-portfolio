# 📓 Daily Engineering Log — 30 Dec 2025

## Focus Areas
AKS platform engineering, Helm standardisation, and Application Insights observability validation.

## Work Completed
- Continued validation of **Application Insights telemetry** for `golden-app`.
- Deployed and tested **App Insights integration via Helm**, using connection string injection from Kubernetes secrets.
- Added structured logging to the ASP.NET Core app and verified runtime startup logs.
- Executed **egress connectivity tests** from AKS pods to Azure Monitor ingestion and Live endpoints using `curlimages/curl`.
- Reviewed and refined **Helm golden chart observability values**, including:
  - Environment tagging
  - Service naming consistency
  - Secret-based configuration
- Confirmed pipeline execution passes for Helm deployments in the `test` namespace.
- Updated platform tracker to mark:
  - Helm standardisation ✅
  - Golden chart implementation ✅
  - Runtime documentation completion ✅

## Issues / Observations
- Application Insights **logs not appearing as expected**, despite:
  - Correct connection string
  - Successful network egress
  - SDK enabled
- Likely cause is **sampling, log level filtering, or missing provider configuration**, not networking.
- AKS + Azure RBAC restrictions continue to add friction during cluster-level debugging.

## Decisions Made
- Treat observability as a **runtime concern**, not just an infrastructure checkbox.
- Clearly separate:
  - *Telemetry wired correctly*
  - *Telemetry useful and visible*
- Continue capturing operational expectations in `/docs/platform-runtime.md`.

## Next Actions
- Explicitly configure:
  - LogLevel filters
  - Application Insights logger provider options
- Add a **known-good telemetry smoke test endpoint**.
- Query **Log Analytics (`traces` table)** directly instead of relying solely on the App Insights blade.
- Final polish on runtime documentation and observability runbook.

## Energy Check
- Medium-to-low energy, high signal output.
- Solid stopping point: platform stable, problems clearly framed for the next session.
