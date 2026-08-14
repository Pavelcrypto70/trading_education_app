# GitHub Actions secrets — copy-paste values
# https://github.com/Pavelcrypto70/trading_education_app/settings/secrets/actions

## Already known (paste these now)

| Secret name | Value |
|-------------|-------|
| `SUPABASE_URL` | `https://akwiexmyblpuckvbqjsd.supabase.co` |
| `SUPABASE_ANON_KEY` | `sb_publishable_FL4lJ9uRe-S2FNw2bdD9fA_7fwI0NvQ` |
| `SUPABASE_PROJECT_REF` | `akwiexmyblpuckvbqjsd` |

## You must create (one time each)

### SUPABASE_ACCESS_TOKEN
1. https://supabase.com/dashboard/account/tokens
2. **Generate new token** → copy `sbp_...`
3. New repository secret → name: `SUPABASE_ACCESS_TOKEN`

### PAGES_DEPLOY_TOKEN
1. https://github.com/settings/tokens/new?scopes=repo&description=Trade%20Master%20Pages
2. Generate → copy `ghp_...`
3. New repository secret → name: `PAGES_DEPLOY_TOKEN`

## After secrets are set

1. **Actions** → **Deploy Supabase Edge Functions** → **Run workflow**
2. **Actions** → **Deploy to GitHub Pages** → **Run workflow**

Or push to `main` — workflows run automatically.

## Or via script (if GitHub CLI installed)

```powershell
$env:SUPABASE_ACCESS_TOKEN="sbp_..."
$env:PAGES_DEPLOY_TOKEN="ghp_..."
.\tools\set_github_secrets.ps1
.\tools\deploy_supabase_functions.ps1
.\tools\deploy_pages.ps1
```
