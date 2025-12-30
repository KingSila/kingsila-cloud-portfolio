# Daily Log — 22 Nov 2025
**Project:** Azure | Terraform | DevOps Portfolio
**Author:** KingSila
**Focus:** Governance · CI/CD · Prod Environment · Tooling

---

## 🔥 Summary of the Day
A seriously productive day. You moved from a working dev/test pipeline into a fully governed, multi-environment Azure platform with prod-level safety controls. Governance is live, CI/CD is clean, OIDC is secure, destroy pipelines have approvals, and pre-commit hooks now enforce Terraform quality locally. You basically levelled up the entire project’s maturity in one sprint.

---

## ✅ Completed Today

### **1. Governance Stack Finalized**
- Fixed policy assignment with correct AzureRM resource type
- Added subscription-level allowed locations policy
- Added RBAC roles via Terraform (Owner + Contributor)
- Imported existing role assignments to prevent conflicts
- Successfully ran governance `apply` end-to-end
- Verified policy enforcement through real Azure deny test

### **2. Destroy Pipeline Fully Operational**
- Built full Terraform destroy workflow with:
  - `DESTROY` confirmation gate
  - GitHub environment approvals
  - OIDC authentication
  - Artifact-based plan/apply model
- Fixed OIDC subject mismatch for `dev-destroy`
- Destroy tested successfully via CI/CD

### **3. Prod Environment Created & Operational**
- Cloned dev → prod environment structure
- Updated environment variable validations to include `prod`
- Added required maps/configs for prod settings
- Federated identity added for `environment:prod`
- Prod Terraform plan/apply working through CI/CD
- Prod destroy pipeline also functional with approvals

### **4. Terraform Tooling Upgrade**
- Installed and configured `pre-commit`
- Added hooks:
  - `terraform fmt`
  - `terraform validate`
  - `tflint`
  - whitespace + merge-conflict checks
- Ensured VS Code Git commits trigger hooks automatically

### **5. Tracker Updated**
- Marked Week 3–4 tasks complete
- Confirmed next focus: Week 5–6 (Security & Secrets)
- Cleaned and corrected entire `TRACKER.md`

---

## 🧠 Lessons & Insights

- GitHub OIDC *requires* exact subject match; each environment needs its own federated credential.
- Governance + policy enforcement becomes extremely real once you see a `403` block from Azure.
- CI/CD is much cleaner when apply and destroy are separated into explicit workflows with approvals.
- Pre-commit removes 90% of “oops I forgot fmt” before pushing anything to the pipeline.

---

## 🚀 Next Steps (Tomorrow)
Based on the tracker, the next major milestone is **Week 5–6 Security**.
Recommended first item:

**➡️ Integrate Azure Key Vault + Secret References for App Service**

This means:
- Creating a Key Vault module
- Wiring it into dev/test/prod
- Assigning RBAC to managed identities
- Using Key Vault References in App Service configuration

A great next step to build security muscles.

---

## 🏁 End of Day Status
**All environments operational:** dev, test, prod
**Governance active:** Yes
**Pipelines healthy:** Yes
**Destroy workflows safe & controlled:** Yes
**Developer tooling enforced:** Yes

You built a serious platform today.
