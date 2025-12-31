#!/usr/bin/env bash
set -euo pipefail

# -------------------------------
# Args
# -------------------------------
AUTO_PROTECT=false
BRANCH="main"
REPO="KingSila/kingsila-cloud-portfolio"
APPROVALS=1
STATUS_CHECKS=()

# Parse flags
while [[ $# -gt 0 ]]; do
  case "$1" in
    --auto-protect)
      AUTO_PROTECT=true
      shift
      ;;
    --branch)
      BRANCH="$2"
      shift 2
      ;;
    --repo)
      REPO="$2"
      shift 2
      ;;
    --approvals)
      APPROVALS="$2"
      shift 2
      ;;
    --checks)
      shift
      while [[ $# -gt 0 && "$1" != --* ]]; do
        STATUS_CHECKS+=("$1")
        shift
      done
      ;;
    *)
      echo "Unknown argument: $1"
      exit 1
      ;;
  esac
done

RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
CYAN="\033[36m"
RESET="\033[0m"

REPO_URL="https://github.com/$REPO"

# -------------------------------
# Header
# -------------------------------
echo -e "${CYAN}"
cat << "EOF"
╔════════════════════════════════════════════════════════════════════╗
║         GitHub Branch Protection & Environment Setup              ║
╚════════════════════════════════════════════════════════════════════╝
EOF
echo -e "${RESET}"

echo -e "${CYAN}This script guides you through configuring:${RESET}"
echo "  ✓ Branch protection rules"
echo "  ✓ GitHub environments (dev, test, destroy)"
echo "  ✓ Deployment protections"
echo ""

# -------------------------------
# Auto Branch Protection
# -------------------------------
if [[ "$AUTO_PROTECT" == true ]]; then
  echo -e "\n${CYAN}⚙️ Applying branch protection automatically for '$BRANCH'...${RESET}"

  if ! command -v gh >/dev/null; then
    echo -e "${RED}GitHub CLI (gh) not installed. Install from https://cli.github.com${RESET}"
    exit 1
  fi

  # Construct JSON payload
  CHECKS_JSON=$(printf '%s\n' "${STATUS_CHECKS[@]}" | jq -R . | jq -s .)

  PAYLOAD=$(jq -n \
    --argjson checks "$CHECKS_JSON" \
    --arg branch "$BRANCH" \
    --argjson approvals "$APPROVALS" \
    '
    {
      required_pull_request_reviews: {
        required_approving_review_count: $approvals,
        require_code_owner_reviews: false,
        require_last_push_approval: false,
        dismiss_stale_reviews: true
      },
      enforce_admins: true,
      required_linear_history: true,
      required_conversation_resolution: true,
      allow_force_pushes: false,
      allow_deletions: false,
      restrictions: null,
      required_status_checks: {
        strict: true,
        contexts: $checks
      }
    }
    '
  )

  TMPFILE=$(mktemp)
  echo "$PAYLOAD" > "$TMPFILE"

  if gh api -X PUT "repos/$REPO/branches/$BRANCH/protection" \
       -H "Accept: application/vnd.github+json" \
       --input "$TMPFILE" >/dev/null; then
    echo -e "${GREEN}✅ Branch protection applied.${RESET}"
  else
    echo -e "${RED}❌ Failed to apply protection.${RESET}"
  fi

  rm -f "$TMPFILE"
else
  echo -e "${YELLOW}Skipping automatic protection…${RESET}"
fi

# -------------------------------
# Manual Checklist
# -------------------------------
echo -e "\n${YELLOW}📋 CHECKLIST${RESET}"
echo -e "${CYAN}Go to:${RESET} $REPO_URL/settings/branches"

echo ""
echo -e "${GREEN}1. BRANCH PROTECTION RULES${RESET}"
echo "   ✓ Add rule for: main"
echo "   ✓ Require PR before merging"
echo "   ✓ Require approvals: $APPROVALS"
echo "   ✓ Require status checks:"
printf "     - %s\n" "${STATUS_CHECKS[@]:-Terraform Plan - dev}"
echo "     - Terraform Plan - test"
echo "   ✓ Require linear history"
echo "   ✓ Require conversation resolution"
echo ""

read -rp "Press Enter when branch protection is configured..."

# -------------------------------
# Environments
# -------------------------------
echo -e "\n${GREEN}2. GITHUB ENVIRONMENTS${RESET}"
echo -e "Go to: ${CYAN}$REPO_URL/settings/environments${RESET}"

setup_env() {
  local name="$1"
  local reviewers="$2"
  local wait="$3"

  echo -e "\n📦 Environment: ${CYAN}$name${RESET}"
  echo "   ✓ Create environment: $name"
  echo "   ✓ Required reviewers: $reviewers"
  [[ $wait != "0" ]] && echo "   ✓ Wait timer: $wait minutes"
  echo "   ✓ Deployment branches: main"
  echo ""

  read -rp "Press Enter when '$name' is configured..."
}

setup_env "dev" 0 0
setup_env "dev-destroy" 1 0
setup_env "test" 1 5
setup_env "test-destroy" 1 5

# -------------------------------
# Verification
# -------------------------------
echo -e "\n${GREEN}3. VERIFICATION${RESET}"
echo -e "${YELLOW}Try this:${RESET}"

echo "
git checkout -b feature/test-branch-protection
echo '## Test' >> README.md
git add .
git commit -m 'test: verify branch protection'
git push origin feature/test-branch-protection
"

read -rp "Run test automatically? (y/n): " run_test

if [[ "$run_test" == "y" ]]; then
  echo -e "\n${CYAN}🚀 Creating test branch...${RESET}"

  git checkout -b feature/test-branch-protection
  echo -e "\n## Branch Protection Test\n" >> README.md
  git add .
  git commit -m "test: verify branch protection and CI/CD pipeline"
  git push origin feature/test-branch-protection

  echo -e "\n${GREEN}✅ Test branch pushed!${RESET}"
  echo "Go to: $REPO_URL/pulls"
else
  echo -e "${GREEN}Setup complete. Test anytime.${RESET}"
fi

# -------------------------------
# Final Notes
# -------------------------------
echo -e "\n${GREEN}✨ Setup Complete!${RESET}"
echo -e "${YELLOW}Documentation:${RESET}"
echo "  docs/github-setup.md"
echo "  docs/cicd.md"
echo "  .github/workflows/README.md"
echo ""
