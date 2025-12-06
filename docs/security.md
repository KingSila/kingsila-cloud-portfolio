## Platform Guardrails – Deployment Location Policy

Our cloud platform enforces a subscription-level **Allowed Locations Policy** to ensure all resources are deployed only into approved Azure regions. This provides consistency, governance, and cost/security predictability across all environments.

---

### **What This Policy Does**

The policy denies any deployment where the target Azure region is *not* part of the allowed list defined for that environment.
If a resource attempts to deploy to a disallowed region, Azure Policy blocks the request before the resource is created.

---

### **Environments Covered**

This guardrail is applied to all environments managed by Terraform:

- **dev**
- **test**
- **prod**

Each environment can have its own region list, depending on business or compliance requirements.

---

### **Where Allowed Locations Are Configured**

Allowed regions are defined in two places:

1. **Environment tfvars files**
   Example:
   `infra/envs/dev/dev.tfvars`
   ```hcl
   allowed_locations = ["southafricanorth", "southafricawest"]
