# 📘 Daily Log – Terraform, RBAC & CI/CD Wrestling
**Date:** 2025-11-27
**Author:** KingSila

## 🎯 Focus for Today
Today centered on taming the Key Vault RBAC issues, stabilizing Terraform behavior, and improving the CI/CD workflow structure.

---

## 🧪 What Happened
- Investigated recurring **403 Forbidden** errors from Key Vault during Terraform secret read/write operations.
- Confirmed the issue was tied to **missing RBAC permissions** and **role propagation delays**.
- Re-ran Terraform operations to verify successful role assignment creation.
- Reviewed GitHub Actions Terraform CI/CD workflow and identified areas for refinement.
- Updated internal notes and mental map of environment-based authentication.

---

## 🔧 Issues Encountered
- Role assignments taking longer than usual to propagate.
- Secret operations blocked until RBAC fully synced.
- Conflicting signals from Terraform during Key Vault operations.

---

## ✅ Wins for Today
- Clarified correct RBAC access needed for Terraform's Key Vault interactions.
- Strengthened understanding of clean OIDC integration per environment.
- Made progress toward a more reliable Terraform CI/CD pipeline.

---

## 📌 Notes for Tomorrow
- Finalize CI/CD enhancements for environment promotion flow.
- Re-test Terraform actions after RBAC propagation finishes.
- Clean up remaining workflow logic and safeguards.

---

## 🧾 Suggested Commit Message
