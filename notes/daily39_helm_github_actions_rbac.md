# 📅 Daily Engineering Log
**Date:** 2025-12-27
**Focus:** AKS · GitHub Actions · Helm · Azure RBAC

---

## 🎯 Objectives
- Continue AKS deployment pipeline work (dev/test)
- Validate Helm-based application deployment
- Untangle Azure RBAC vs Kubernetes RBAC behavior
- Stabilize GitHub Actions workflow for AKS deployments

---

## ✅ What Was Done

- Reviewed and refined **GitHub Actions workflow** for AKS deployments
  - Environment selection via `workflow_dispatch`
  - OIDC-based Azure login confirmed
  - Environment-specific resource group & AKS cluster resolution

- Explored **Helm fundamentals** in context of AKS
  - Clarified Helm’s role as a **Kubernetes package manager**, not an Azure Policy equivalent
  - Mapped Helm concepts:
    - Chart → application template
    - Release → deployed instance
    - Values → environment-specific configuration

- Investigated **Azure RBAC–backed AKS access issues**
  - Observed `Forbidden` errors when accessing namespaces and service accounts
  - Confirmed behavior is expected with `enable_azure_rbac = true`
  - Identified missing Azure role assignments as root cause (not Kubernetes YAML issues)

- Reviewed namespace and ingress-related errors
  - Confirmed failures stem from **identity permissions**, not manifest syntax
  - Reinforced separation of concerns:
    - Azure RBAC → who can talk to the cluster
    - Kubernetes RBAC → what they can do inside it

---

## 🧠 Key Learnings

- Helm is closer to **Terraform for Kubernetes apps**, not Azure Policy
  It installs, upgrades, and versions workloads—it doesn’t enforce governance rules.

- With **Azure RBAC enabled on AKS**, Kubernetes access is gated by Azure roles first
  If Azure says “no,” Kubernetes never even gets a vote.

- Most “kubectl forbidden” errors today were **identity problems**, not YAML problems
  The YAML was innocent. The permissions were guilty.

---

## ⚠️ Challenges / Friction

- Azure RBAC role gaps causing namespace and service account access failures
- Cognitive load from switching between:
  - Azure IAM
  - Kubernetes RBAC
  - Helm abstractions
  - GitHub Actions context

(No actual fires. Just controlled burns.)

---

## 🔜 Next Steps

- Assign correct Azure roles for AKS access (cluster user/admin as appropriate)
- Finalize Helm release workflow for test environment
- Deploy app via Helm into dedicated namespace
- Validate ingress access path (once permissions stop blocking reality)

---

## 🧘 Closing Thought

Today was less about shipping features and more about **understanding the rules of the universe** this platform lives in.
Once you know who’s allowed to touch the cluster, everything else suddenly behaves.

Progress made. Sanity mostly intact.
