Daily Log – 2025-12-01
Overview

Today’s work focused on fixing Terraform backend issues, updating the policy assignment module to support AzureRM v4, and restoring a clean execution path for the dev environment. By the end of the session, terraform plan and terraform apply executed successfully.

Backend Fixes

Resolved backend error: blobName cannot be an empty string.

Provided explicit backend key using:

terraform init -backend-config="key=dev/terraform.tfstate" -upgrade


Cleaned .terraform directory and successfully reinitialized modules.

Policy Module Migration (AzureRM v4)

Deprecated azurerm_policy_assignment removed.

Implemented azurerm_subscription_policy_assignment for v4 compatibility.

Added required module variables:

subscription_id

policy_definition_id

parameters

identity_type

location, enforcement_mode, etc.

Updated outputs to reference the new v4 resource.

Added JSON-encoding for parameters and dynamic identity support.

Scope & Subscription Fix

Corrected subscription format from:

<guid>


to the required ARM scope:

/subscriptions/<guid>


Resolved provider parsing errors related to scope formatting.

Planning & Deployment

Used:

terraform plan -var-file="env/dev.tfvars"


to validate configuration with environment values.

Resolved remaining module reference issues.

Dev environment terraform apply now completes without errors.

Outputs such as keyvault_uri and webapp_url return expected values after apply.

End-of-Day Status

Backend stable

Policy module fully v4-compatible

Validation successful

Dev apply working

No blocking issues remaining

Next Steps

Verify policy enforcement behavior in dev.

Apply updated module structure to test and prod.

Add optional remediation (SystemAssigned identity) when needed.

Improve per-environment automation for backend config and validation.
