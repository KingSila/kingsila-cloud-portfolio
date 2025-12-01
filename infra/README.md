# Infrastructure Documentation

This folder contains all Terraform configurations used to deploy the dev, test, and prod environments.
Each environment is driven through `.tfvars` files and matched to its own Azure Key Vault instance.

---

## Running Terraform Locally

Terraform is environment-driven. Always point to the correct `tfvars` file.

### Initialize
```bash
terraform init

Plan
terraform plan -var-file="env/dev.tfvars"
terraform plan -var-file="env/test.tfvars"
terraform plan -var-file="env/prod.tfvars"

Apply
terraform apply -var-file="env/dev.tfvars"
terraform apply -var-file="env/test.tfvars"
terraform apply -var-file="env/prod.tfvars"

Notes

Azure authentication uses OIDC — no service principal secrets stored.

Each environment has its own TERRAFORM_PRINCIPAL_OBJECT_ID_* secret.

Connection strings are stored per environment in their Key Vault and injected at deployment.

Region restrictions are handled through allowed_locations in variables.
