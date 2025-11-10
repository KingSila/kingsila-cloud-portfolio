# Branch Protection & GitHub Environment Setup Guide

## Branch Protection Rules

### Setting Up Branch Protection for `main`

1. **Navigate to Settings**
   - Go to your repository on GitHub
   - Click **Settings** → **Branches** → **Add branch protection rule**

2. **Branch Name Pattern**
   ```
   main
   ```

3. **Recommended Protection Rules**

   #### ✅ Require a pull request before merging
   - **Require approvals**: 1 (for solo project) or 2+ (for team)
   - ☑️ Dismiss stale pull request approvals when new commits are pushed
   - ☑️ Require review from Code Owners (optional)

   #### ✅ Require status checks to pass before merging
   - ☑️ Require branches to be up to date before merging
   - **Required status checks:**
     - `Terraform Plan - dev`
     - `Terraform Plan - test`

   #### ✅ Require conversation resolution before merging
   - Forces all PR comments to be resolved

   #### ✅ Require linear history
   - Prevents merge commits, enforces rebase or squash

   #### ⚠️ Do not require (for solo project)
   - ❌ Require deployments to succeed (not needed for Terraform)
   - ❌ Lock branch (prevents all pushes)

   #### ✅ Rules applied to administrators
   - ☑️ Include administrators (recommended for discipline)

   #### ✅ Restrictions (Optional)
   - Leave empty for solo project
   - For teams: restrict who can push to main

4. **Click "Create"**

---

## GitHub Environments Setup

### Environment: `dev`

**Purpose:** Development environment, auto-deploys on merge to main

1. **Navigate to Environments**
   - Settings → Environments → New environment
   - Name: `dev`

2. **Environment Protection Rules**
   - ❌ Required reviewers: None (auto-deploy)
   - ☑️ Wait timer: 0 minutes
   - ☑️ Deployment branches: Selected branches
     - Add rule: `main`

3. **Environment Secrets** (if different from repo secrets)
   - Usually inherit from repository secrets
   - Can override if dev uses different credentials

4. **Click "Save protection rules"**

---

### Environment: `dev-destroy`

**Purpose:** Approve infrastructure destruction in dev

1. **Create Environment**
   - Name: `dev-destroy`

2. **Environment Protection Rules**
   - ☑️ Required reviewers: 1
   - ☑️ Wait timer: 0 minutes
   - ☑️ Deployment branches: `main` only

3. **Click "Save protection rules"**

---

### Environment: `test`

**Purpose:** Test environment, requires approval before deploy

1. **Create Environment**
   - Name: `test`

2. **Environment Protection Rules**
   - ☑️ Required reviewers: 1
   - ☑️ Wait timer: 5 minutes (gives you time to cancel)
   - ☑️ Deployment branches: `main` only

3. **Reviewers**
   - Add yourself or team members

4. **Click "Save protection rules"**

---

### Environment: `test-destroy`

**Purpose:** Approve infrastructure destruction in test (stricter)

1. **Create Environment**
   - Name: `test-destroy`

2. **Environment Protection Rules**
   - ☑️ Required reviewers: 1 (or 2 for extra safety)
   - ☑️ Wait timer: 5 minutes
   - ☑️ Deployment branches: `main` only

3. **Click "Save protection rules"**

---

## Verification Checklist

After setting up, verify:

- [ ] Cannot push directly to main
- [ ] PR requires status checks to pass
- [ ] Terraform plan runs on PR creation
- [ ] PR comments show Terraform plan output
- [ ] Merge to main triggers deployment to dev
- [ ] Test deployment requires manual approval
- [ ] Destroy workflows require confirmation

---

## Testing Branch Protection

### Test 1: Direct Push (Should Fail)

```bash
# This should be blocked
git checkout main
echo "test" >> README.md
git commit -am "test direct push"
git push origin main
```

**Expected:** ❌ Push rejected by branch protection

---

### Test 2: Pull Request Flow (Should Work)

```bash
# Create feature branch
git checkout -b feature/test-branch-protection
echo "## Testing" >> README.md
git commit -am "docs: test branch protection"
git push origin feature/test-branch-protection

# Create PR on GitHub
# Wait for status checks
# Merge when checks pass
```

**Expected:** ✅ PR created, checks run, can merge after approval

---

## Branch Protection Rules Summary

| Rule | Enabled | Purpose |
|------|---------|---------|
| Require PR | ✅ | Prevents direct pushes to main |
| Require approvals | ✅ | Code review required |
| Require status checks | ✅ | CI/CD must pass |
| Conversation resolution | ✅ | All comments addressed |
| Linear history | ✅ | Clean git history |
| Applied to admins | ✅ | No shortcuts |

---

## GitHub Environments Summary

| Environment | Reviewers | Wait Time | Purpose |
|-------------|-----------|-----------|---------|
| `dev` | 0 | 0 min | Auto-deploy dev |
| `dev-destroy` | 1 | 0 min | Approve dev destruction |
| `test` | 1 | 5 min | Manual test deployment |
| `test-destroy` | 1 | 5 min | Approve test destruction |

---

## Common Issues & Solutions

### Issue: Status checks not showing up

**Solution:**
- Create a PR first
- Workflows must run at least once
- Check workflow file paths match triggers

### Issue: Can't find required status checks

**Solution:**
- Go to branch protection settings
- Click "Require status checks"
- Search for check names from Actions tab
- They appear only after first workflow run

### Issue: Approval not triggering

**Solution:**
- Ensure reviewers are added to environment
- Check environment name matches workflow
- Verify deployment branch rules

### Issue: Workflow not running

**Solution:**
- Check workflow file syntax
- Verify triggers match your actions
- Check file paths in `paths:` filter
- Review Actions tab for errors

---

## Next Steps

1. ✅ Set up branch protection rules
2. ✅ Create GitHub environments
3. ✅ Test with a sample PR
4. ✅ Verify approval process works
5. ✅ Document any custom configurations

---

## Resources

- [GitHub Branch Protection](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches/about-protected-branches)
- [GitHub Environments](https://docs.github.com/en/actions/deployment/targeting-different-environments/using-environments-for-deployment)
- [Required Status Checks](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches/about-protected-branches#require-status-checks-before-merging)
