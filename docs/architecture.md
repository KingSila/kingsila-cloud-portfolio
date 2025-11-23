# Architecture Overview

## 🔷 Objective
Demonstrate a secure, automated, and observable Azure landing zone deployed via Terraform.

## 🏗️ High-Level Components
- **Hub-and-Spoke Network**
  Hub hosts shared services (Firewall, Bastion, DNS).
  Spokes for App, Data, and AKS workloads.

- **Identity & Access**
  - Azure AD + Managed Identities
  - Role-based access via Terraform RBAC assignments

- **Automation**
  - GitHub Actions pipeline triggers Terraform plan/apply
  - Separate environments: dev → test → prod
  - Manual approval gates

- **Security & Compliance**
  - Azure Policy for tag & location compliance
  - Defender for Cloud baseline recommendations

- **Observability**
  - Azure Monitor, Log Analytics, Application Insights

## 🗺️ Diagram (placeholder)
`/images/architecture-diagram.png`

## 🧾 Future Enhancements
- Add Bicep comparison
- Integrate Terraform Cloud workspaces
- Extend GitOps for AKS workloads
