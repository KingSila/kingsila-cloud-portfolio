# Daily Log — 2025-12-21
## Subject: AKS Workload Identity (Private Cluster, Dev)

### Objective
Enable and validate Azure Workload Identity on a private AKS dev cluster while operating from a corporate network, without using secrets in workloads.

---

### Work Completed
- Enabled **AKS Workload Identity** and verified OIDC issuer availability
- Confirmed workload identity webhook is running in `kube-system`
- Created **User Assigned Managed Identity (UAMI)** with policy-compliant tags
- Created **federated identity credential** binding:
  - AKS OIDC issuer
  - `system:serviceaccount:dev:app-sa`
- Configured Kubernetes `ServiceAccount` for workload identity
- Injected Azure context safely using a **ConfigMap** (no secrets committed)
- Validated workload identity end-to-end using an in-cluster test pod
- Confirmed pod authentication via **federated token**, not node/system MSI
- Successfully accessed Azure Resource Group using RBAC-scoped identity
- Used `az aks command invoke` for all cluster interactions due to private AKS and corporate DNS constraints

---

### Key Technical Notes
- Azure CLI `az login --identity` defaults to IMDS/MSI and can ignore workload identity
- Correct approach for WI validation:
  - Use `az login --service-principal`
  - Authenticate via federated token (`AZURE_FEDERATED_TOKEN_FILE`)
- Workload identity webhook requires explicit pod labeling:
  - `azure.workload.identity/use: "true"`
- Public repository safety maintained by:
  - Avoiding hardcoded subscription IDs and client secrets
  - Externalizing environment-specific values via ConfigMaps and runtime injection

---

### Challenges & Resolutions
- **Issue:** Pod authenticated as system-assigned identity
  **Resolution:** Ensured workload identity webhook injection and explicit `AZURE_CLIENT_ID` usage

- **Issue:** `CreateContainerConfigError` on test pod
  **Resolution:** Created required ConfigMap before pod startup

- **Issue:** Corporate DNS could not resolve private AKS API
  **Resolution:** Used `az aks command invoke` as a kubectl proxy

---

### Outcome
✅ Workload Identity fully operational on private AKS
✅ No secrets used in pods
✅ Public repo remains security-compliant
✅ Foundation ready for ingress and CI/CD pipeline work

---

### Next Steps
- Configure NGINX ingress baseline for dev environment
- Prepare test environment AKS deployment pipeline using OIDC
