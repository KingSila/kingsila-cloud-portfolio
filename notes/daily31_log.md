# 🗓️ Daily Log – 13 December 2025

## 🌍 Platform Layer Progress
- Corrected platform VNet configuration and ensured proper CIDR alignment.
- VNet now cleanly defined as **10.20.0.0/16** with dedicated AKS subnets:
  - `10.20.1.0/24` (dev)
  - `10.20.2.0/24` (test)
  - `10.20.3.0/24` (prod)
- All three AKS subnets created successfully after resolving range mismatches.
- Fixed lingering Key Vault RBAC conflict (`RoleAssignmentExists`) by aligning Terraform state with Azure.

## 🚀 AKS Cluster Work (Dev)
- Started provisioning **aks-kingsila-dev**.
- Corrected `max_pods` misconfiguration (Azure requires ≥10, old value was 5).
- Encountered policy block: **Allowed Locations (dev)** denied AKS private DNS zone creation due to `global` not being allowed.
- Updated dev allowed locations to include `"global"` to support AKS private DNS zones.
- Re-applied policy layer → unblock successful.

## 🔒 Azure Policy Highlights
- Verified full policy lifecycle: definition → assignment → enforcement → impact on AKS.
- Learned that some Azure services (private DNS zones, Traffic Manager, etc.) legitimately deploy in the `"global"` location even in regional architectures.

## 🧠 Architecture Progress Today
- Affirmed platform-first networking model: shared VNet + env-specific AKS clusters.
- Confirmed private AKS cluster design works after policy adjustments.
- Clean separation: platform owns VNet; environments consume subnets.

## ⚙️ Tasks for Tomorrow
- Validate AKS cluster creation and pull kubeconfig.
- Run initial cluster checks: nodes, namespaces, OIDC issuer availability.
- Add outputs for AKS module (cluster name, node RG, OIDC, etc.).
- Begin *Workload Identity* setup (managed identity + federated credential).
- Prepare ingress (NGINX) installation strategy for dev.

## 🧘 Energy Notes
Low energy but high output.
Progress made across networking, RBAC, policy, and AKS provisioning.
Multiple cloud dragons defeated.
Tomorrow: refinement and workload identity bootstrapping.
