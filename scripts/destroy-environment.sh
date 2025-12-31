#!/usr/bin/env bash

set -euo pipefail

# ----------------------------------------
# Arguments
# ----------------------------------------
ENVIRONMENT="dev"
PLAN_FIRST="false"
SUMMARY_FILE=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    -e|--environment)
      ENVIRONMENT="$2"
      shift 2
      ;;
    --plan-first)
      PLAN_FIRST="true"
      shift
      ;;
    -s|--summary-file)
      SUMMARY_FILE="$2"
      shift 2
      ;;
    *)
      echo "Unknown argument: $1"
      echo "Usage: $0 [-e dev|test|prod] [--plan-first] [-s SUMMARY_FILE]"
      exit 1
      ;;
  esac
done

# ----------------------------------------
# Validation
# ----------------------------------------
if [[ "$ENVIRONMENT" != "dev" && "$ENVIRONMENT" != "test" && "$ENVIRONMENT" != "prod" ]]; then
  echo "Environment must be 'dev', 'test', or 'prod'"
  exit 1
fi

ENV_PATH="infra/envs/$ENVIRONMENT"
BACKEND_FILE="backend-$ENVIRONMENT.hcl"
TFVARS_FILE="$ENVIRONMENT.tfvars"

if [[ ! -d "$ENV_PATH" ]]; then
  echo "Environment path not found: $ENV_PATH"
  exit 1
fi

cd "$ENV_PATH"

if [[ ! -f "$BACKEND_FILE" ]]; then
  echo "Backend config not found: $BACKEND_FILE"
  echo "Expected at: $ENV_PATH/$BACKEND_FILE"
  exit 1
fi

if [[ ! -f "$TFVARS_FILE" ]]; then
  echo "TFVARS file not found: $TFVARS_FILE"
  echo "Expected at: $ENV_PATH/$TFVARS_FILE"
  exit 1
fi

# ----------------------------------------
# Pretty header (because style matters)
# ----------------------------------------
header() {
  echo -e "\n=== $1 ==="
}

header "Destroy Environment: $ENVIRONMENT"

# ----------------------------------------
# Terraform init (using per-env backend)
# ----------------------------------------
if [[ ! -d ".terraform" ]]; then
  header "Terraform Init (backend: $BACKEND_FILE)"
  terraform init -backend-config="$BACKEND_FILE"
fi

# ----------------------------------------
# Destroy workflow
# ----------------------------------------
if [[ "$PLAN_FIRST" == "true" ]]; then
  header "Terraform Destroy Plan"
  terraform plan -destroy -var-file="$TFVARS_FILE" -out="${ENVIRONMENT}-destroy.plan"

  header "Terraform Destroy (from plan)"
  terraform apply -auto-approve "${ENVIRONMENT}-destroy.plan"
else
  header "Terraform Destroy (direct)"
  terraform destroy -auto-approve -var-file="$TFVARS_FILE"
fi

# ----------------------------------------
# Remaining state
# ----------------------------------------
header "Post-Destroy State"
if REMAINING=$(terraform state list 2>/dev/null); then
  echo "Remaining managed objects (likely backend-related):"
  echo "$REMAINING" | sed 's/^/ - /'
else
  echo "No resources remain in state."
  REMAINING=""
fi

# ----------------------------------------
# Summary logging
# ----------------------------------------
if [[ -n "$SUMMARY_FILE" ]]; then
  SUMMARY_PATH="../../$SUMMARY_FILE"

  {
    echo ""
    echo "### Environment Destroyed: $ENVIRONMENT ($(date '+%Y-%m-%d %H:%M'))"
    if [[ -n "$REMAINING" ]]; then
      echo "Remaining state objects:"
      echo "$REMAINING" | sed 's/^/- /'
    else
      echo "All resources destroyed."
    fi
  } >> "$SUMMARY_PATH"

  echo "Summary appended to $SUMMARY_FILE"
fi
