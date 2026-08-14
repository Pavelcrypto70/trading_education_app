# Store release checklist — Trade Master

Package: `com.trademaster.education`  
Product: `trade_master_lifetime_full` (non-consumable lifetime, **not** auto-renew subscription)  
UI / StoreKit price: **$9.99**

## 1. One-time local setup

```powershell
# Upload keystore (creates android/keystore + android/key.properties — gitignored)
powershell -ExecutionPolicy Bypass -File tools/create_upload_keystore.ps1

# Secrets for builds
copy dart_defines.example.json dart_defines.json
# fill SUPABASE_URL / SUPABASE_ANON_KEY / partner URLs

flutter pub get
dart run flutter_launcher_icons
dart run flutter_native_splash:create
```

Back up `upload-keystore.jks` + passwords offline. Losing them blocks Play updates for this upload key.

## 2. Supabase (required for IAP + delete account)

Deploy functions:

```bash
supabase functions deploy verify-purchase
supabase functions deploy delete-account
supabase functions deploy stripe-checkout   # web only
supabase functions deploy stripe-webhook    # web only
```

Secrets (Dashboard → Edge Functions):

| Secret | Purpose |
|--------|---------|
| `GOOGLE_PLAY_SERVICE_ACCOUNT_JSON` | Android purchase verify |
| `APPLE_SHARED_SECRET` | iOS receipt verify (if enabled in verify-purchase) |
| `STRIPE_*` | Web checkout |

Confirm products Active in Play Console + App Store Connect with ID `trade_master_lifetime_full`.

## 3. Android Play AAB

```bash
flutter build appbundle --flavor play --release --dart-define-from-file=dart_defines.json
```

Output: `build/app/outputs/bundle/playRelease/app-play-release.aab`

Without `android/key.properties`, release is **debug-signed** — do not upload.

## 4. iOS IPA

1. Set Team in Xcode (Runner target → Signing & Capabilities).
2. Attach `ios/TradeMaster.storekit` for local IAP testing.
3. Archive → Distribute App.

```bash
flutter build ipa --release --dart-define-from-file=dart_defines.json
```

## 5. Pre-submit QA

- [ ] Trial lessons `{1,2,3,7,10}` free; paywall on others
- [ ] Purchase → premium unlock; Restore Purchases
- [ ] Profile → Export my data
- [ ] Profile → Delete account (signed-in) → cannot sign in with same cloud user
- [ ] Privacy / Terms open
- [ ] Adaptive icon + dark splash
- [ ] No debug signing on AAB (`jarsigner -verify` / Play Console)

## 6. Console metadata (manual — not in repo)

Play / App Store screenshots, short/long description, content rating questionnaire, privacy nutrition labels matching `PrivacyInfo.xcprivacy` + `web/privacy.html`.
