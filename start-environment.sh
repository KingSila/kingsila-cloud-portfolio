#!/usr/bin/env bash
set -euo pipefail

# Simple Terraform environment launcher for dev/test/prod
# Usage:
#   ./start-environment.sh dev --plan --summary TRACKER.md
#
# Assumes:
#   infra/envs/<env>/backend-<env>.hcl
#   infra/envs/<env>/<env>.tfvars

ENVIRONMENT="${1:-dev}"
shift || true

PLAN_FIRST=false
SUMMARY_FILE=""

# Parse flags: --plan, --summary <file>
while [[ $# -gt 0 ]]; do
  case "$1" in
    --plan|-p)
      PLAN_FIRST=true
      shift
      ;;
    --summary|-s)
      SUMMARY_FILE="$2"
      shift 2
      ;;
    *)
      echo "Unknown argument: $1"
      exit 1
      ;;
  esac
done

case "$ENVIRONMENT" in
  dev|test|prod) ;;
  *)
    echo "Invalid environment: $ENVIRONMENT (expected dev|test|prod)"
    exit 1
    ;;
esac

echo
echo "=== Environment: $ENVIRONMENT ==="

ENV_PATH="infra/envs/$ENVIRONMENT"
BACKEND_FILE="backend-$ENVIRONMENT.hcl"
TFVARS_FILE="$ENVIRONMENT.tfvars"

if [[ ! -d "$ENV_PATH" ]]; then
  echo "Environment path not found: $ENV_PATH"
  exit 1
fi

cd "$ENV_PATH"

if [[ ! -f "$TFVARS_FILE" ]]; then
  echo "Expected tfvars file not found: $ENV_PATH/$TFVARS_FILE"
  exit 1
fi

echo
echo "=== Terraform Init ==="
if [[ -f "$BACKEND_FILE" ]]; then
  echo "Using backend config: $BACKEND_FILE"
  terraform init -backend-config="$BACKEND_FILE"
else
  echo "Backend config file not found: $BACKEND_FILE"
  echo "Running 'terraform init' without -backend-config."
  terraform init
fi

if $PLAN_FIRST; then
  echo
  echo "=== Terraform Plan ==="
  terraform plan -var-file="$TFVARS_FILE" -out="$ENVIRONMENT.plan"

  echo
  echo "=== Terraform Apply (from plan) ==="
  terraform apply -auto-approve "$ENVIRONMENT.plan"
else
  echo
  echo "=== Terraform Apply (direct) ==="
  terraform apply -auto-approve -var-file="$TFVARS_FILE"
fi

echo
echo "=== Outputs ==="
OUTPUT_JSON="$(terraform output -json || echo '{}')"

if command -v jq >/dev/null 2>&1; then
  # Pretty print to console
  echo "$OUTPUT_JSON" | jq
else
  echo "$OUTPUT_JSON"
fi

if [[ -n "$SUMMARY_FILE" ]]; then
  TS="$(date '+%Y-%m-%d %H:%M')"
  SUMMARY_PATH="$(cd ../.. && pwd)/$SUMMARY_FILE"

  {
    echo
    echo "### Environment Started: $ENVIRONMENT ($TS)"
    if command -v jq >/dev/null 2>&1; then
      echo "$OUTPUT_JSON" | jq -r 'to_entries[] | "- \(.key): \(.value.value)"'
    else
      echo "- Raw outputs (jq not installed)"
    fi
  } >> "$SUMMARY_PATH"

  echo
  echo "Summary appended to $SUMMARY_PATH"
fi
