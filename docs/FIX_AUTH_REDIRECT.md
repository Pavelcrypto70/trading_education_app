# Fix: email login link opens localhost:3000

## Cause
Supabase **Site URL** was `http://localhost:3000`, so magic links in email pointed there.

## Fix in Supabase Dashboard (required — do this now)

1. Open: https://supabase.com/dashboard/project/akwiexmyblpuckvbqjsd/auth/url-configuration  
   (or: Project → **Authentication** → **URL Configuration**)
2. Set **Site URL** to:
   ```
   https://pavelcrypto70.github.io
   ```
3. In **Redirect URLs** add:
   ```
   https://pavelcrypto70.github.io
   https://pavelcrypto70.github.io/**
   ```
4. Save.

## App code (already patched)
- `emailRedirectTo` → production site (never localhost)
- Old emails with localhost links stay broken — request a **new** OTP after Site URL is saved

## Workaround without clicking the link
Enter the **6-digit code** from the email in the app (OTP field) — that works without opening the link.
