# Day 4 Log - November 9, 2025

## 🎯 Today's Focus
- Added GitHub Actions secrets for Azure deployment
- Solved critical Terraform `for_each` issue
- Created automated end-of-day reminder system

---

## ✅ Completed Tasks

### 1. GitHub Actions Secrets Configuration
- Added required secrets to GitHub repository for CI/CD pipeline
- Secrets include Azure credentials and service principal details

### 2. VS Code Task Automation
**Created end-of-day reminder tasks:**
- Added `🚨 END OF DAY: Terraform Destroy (DEV)` task
- Added `🚨 END OF DAY: Terraform Destroy (TEST)` task
- Tasks accessible via `Ctrl+Shift+P` → "Tasks: Run Task"
- Helps prevent overnight Azure costs by reminding to tear down dev/test environments

**Note**: Backend resources (tfstate-rg) should NOT be destroyed - costs ~$0.10/month for state storage

---

## 🐛 Critical Issue Fixed: Terraform `for_each` with Dynamic Values

### The Problem
```
Error: Invalid for_each argument
The "for_each" set includes values derived from resource attributes 
that cannot be determined until apply
```

**Root Cause:**
- Using `for_each = toset(var.subnet_ids)` with a **list** of dynamic subnet IDs
- Terraform couldn't determine the `for_each` keys at plan time because subnet IDs come from VNet module output
- This happened in both NSG and Route Table modules during `terraform destroy`

### The Solution
**Changed from LIST to MAP with static keys:**

#### Before (❌ Doesn't work):
```terraform
# In main.tf
subnet_ids = [
  module.vnet.subnet_ids["app"],
  module.vnet.subnet_ids["data"]
]

# In module variables.tf
variable "subnet_ids" {
  type = list(string)
}

# In module main.tf
resource "azurerm_subnet_route_table_association" "assoc" {
  for_each   = toset(var.subnet_ids)  # ❌ Keys unknown at plan time
  subnet_id  = each.value
  ...
}
```

#### After (✅ Works):
```terraform
# In main.tf
subnet_ids = {
  app  = module.vnet.subnet_ids["app"]
  data = module.vnet.subnet_ids["data"]
}

# In module variables.tf
variable "subnet_ids" {
  type    = map(string)
  default = {}
}

# In module main.tf
resource "azurerm_subnet_route_table_association" "assoc" {
  for_each   = var.subnet_ids  # ✅ Keys (app, data) known at plan time
  subnet_id  = each.value
  ...
}
```

### Why This Works
- **Static Keys**: Terraform knows the map keys (`app`, `data`) at plan time
- **Dynamic Values**: Only the subnet ID values are computed during apply
- **Result**: Terraform can plan the `for_each` loop structure before knowing actual IDs

### Files Modified
1. `infra/modules/nsg/variables.tf` - Changed subnet_ids from list to map
2. `infra/modules/nsg/main.tf` - Updated for_each syntax
3. `infra/modules/route_table/variables.tf` - Changed subnet_ids from list to map
4. `infra/modules/route_table/main.tf` - Updated for_each syntax
5. `infra/environments/dev/main.tf` - Updated module calls + added depends_on
6. `infra/environments/test/main.tf` - Updated module calls + added depends_on

### Additional Safety Measure
Added `depends_on = [module.vnet]` to NSG and Route Table module calls to ensure VNet is created first.

---

## 💡 Key Learnings

### Terraform Best Practice: `for_each` with Dynamic Resources
- **Use maps instead of lists** when `for_each` depends on resource outputs
- **Static keys are essential** - Terraform must know loop iterations at plan time
- **Values can be dynamic** - only keys need to be known upfront
- **Alternative**: Use `-target` to apply in stages (but less elegant)

### Cost Management
- **Backend storage**: ~$0.10/month - keep running
- **Dev/Test environments**: Destroy daily to avoid costs
- **Automation helps**: VS Code tasks make teardown easy

---

## 🔄 Next Steps
- Continue with deployment pipeline setup
- Test the automated destroy tasks regularly
- Monitor Azure costs after implementing daily teardown routine

---

## ⏰ Time Spent
- Last 15 minutes debugging and fixing critical Terraform issue
- Worth it - learned important pattern for dynamic `for_each` usage!
- I am tired today