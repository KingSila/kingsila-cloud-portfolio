# Azure Policies – Allowed Locations

## 1. Policy: `allowed-locations-<env>`

The `allowed-locations-<env>` policy ensures that resources in a given environment
(**dev / test / prod**) can only be created in a specific set of Azure regions.

- If someone tries to deploy to a region **not** in the allowed list, the deployment will fail.
- This helps keep workloads in approved regions for **compliance**, **cost**, and **latency** reasons.

---

## 2. Where the Code Lives

### 2.1 Policy Definition Module

Reusable policy definition for “allowed locations”:

- Path: `infra/modules/policy_definition_allowed_locations`
- Responsibility:
  - Defines the Azure Policy “Allowed locations”
  - Exposes parameters (e.g. `listOfAllowedLocations`) for use by assignments

### 2.2 Policy Assignment Module

Generic module for assigning policies (including allowed locations) to a subscription:

- Path: `infra/modules/policy_assignment`
- Responsibility:
  - Creates `azurerm_subscription_policy_assignment`
  - Wires policy definition + parameters to a specific scope (subscription)

### 2.3 Environment Wiring (`dev`, `test`, `prod`)

Each environment wires these modules together in its own `main.tf`:

- Path pattern: `infra/envs/<env>/main.tf`
  Examples:
  - `infra/envs/dev/main.tf`
  - `infra/envs/test/main.tf`
  - `infra/envs/prod/main.tf`

In each `main.tf`:

- The `policy_definition_allowed_locations` module is instantiated.
- The `policy_assignment` module is used to assign the definition to the subscription.
- The `allowed_locations` value is passed in from the environment’s `*.tfvars`.

---

## 3. How to Change Allowed Locations

To change which regions are allowed for an environment:

1. **Edit the environment tfvars file**

   For example, for **dev**:

   - File: `infra/envs/dev/dev.tfvars`

   Update the `allowed_locations` value, e.g.:

   ```hcl
   allowed_locations = [
     "southafricanorth",
     "southafricawest"
   ]
