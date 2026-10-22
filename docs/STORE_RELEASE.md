# Store release checklist — Trade Master

Package: `com.trademaster.education`  
Product: `trade_master_lifetime_full` (non-consumable lifetime, **not** auto-renew subscription)  
UI / StoreKit price: **$9.99**  
Course: **all lessons free** by default (`COURSE_FREE=true`)

## Store vs web (hard rule)

| | Google Play / Galaxy APK | Web (GitHub Pages) |
|--|--------------------------|--------------------|
| Lessons 1–58 | **Free** (`COURSE_FREE=true`, default) | **Free** (same) |
| Tiger / Desk Club ref | **Forbidden in UI** | Soft recommend `/soft-ref` → `/key` (not required for lessons) |
| Pro chat | Status via account / web | Requires `ref_verified` |
| Optional IAP | Future: pro-layer only — not course unlock | Stripe optional support |
| Owner `/owner-unlock` | Disabled | Allowed |
| Partner exchange links after certificate | Hidden | Shown if `PARTNER_*` URLs set |

Build Play AAB **without** filling `TIGER_REF_*` / `PARTNER_*` in defines (keep empty).

## 1. One-time local setup

```powershell
# Upload keystore (creates android/keystore + android/key.properties — gitignored)
powershell -ExecutionPolicy Bypass -File tools/create_upload_keystore.ps1

# Secrets for builds
copy dart_defines.example.json dart_defines.json
# fill SUPABASE_URL / SUPABASE_ANON_KEY
# leave TIGER_REF_* and PARTNER_* empty for Play

flutter pub get
dart run flutter_launcher_icons
dart run flutter_native_splash:create
```

Back up `upload-keystore.jks` + passwords offline. Losing them blocks Play updates for this upload key.

## 2. Supabase (required for IAP + delete account)

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
| `APPLE_SHARED_SECRET` | iOS receipt verify (if enabled) |
| `STRIPE_*` | Web checkout only |

Confirm product **Active** in Play Console with ID `trade_master_lifetime_full`.

## 3. Android Play AAB

```bash
flutter build appbundle --flavor play --release --dart-define-from-file=dart_defines.json
```

Output: `build/app/outputs/bundle/playRelease/app-play-release.aab`

Without `android/key.properties`, release is **debug-signed** — do not upload.

Optional smoke (strings that must **not** appear in a store-oriented check of UX): Tiger.com referral CTAs, «Бесплатно: ключ Desk Club через Tiger».

## 4. iOS IPA

1. Set Team in Xcode (Runner target → Signing & Capabilities).
2. Attach `ios/TradeMaster.storekit` for local IAP testing.
3. Archive → Distribute App.

```bash
flutter build ipa --release --dart-define-from-file=dart_defines.json
```

## 5. Pre-submit QA (device, playRelease)

- [ ] Lessons **1–14** free without account
- [ ] Lesson **15+** → Play paywall only (no Tiger / no website checkout CTA)
- [ ] Purchase → premium unlock; **Restore Purchases**
- [ ] Profile → Export my data
- [ ] Profile → Delete account (signed-in) → cloud user wiped
- [ ] Privacy / Terms open (`privacy.html` / `terms.html`)
- [ ] Certificate screen has **no** partner/broker cards
- [ ] Stage 5 copy has **no** broker open-account CTA
- [ ] `/owner-unlock` redirects home (no admin bypass)
- [ ] Adaptive icon + dark splash
- [ ] No debug signing on AAB

## 6. Console metadata (owner — not fully automatable)

See `store/PLAY_STORE_LISTING.md` and `store/PLAY_REVIEWER_NOTES.md`.

- Screenshots / feature graphic  
- Data safety + account deletion URL  
- Content rating, financial features declaration  
- License testers + real IAP test  
- App access notes for reviewers  

## 7. Galaxy free flavor (optional, separate)

```bash
flutter build appbundle --flavor galaxy --release --dart-define=ENABLE_BILLING=false --dart-define=STORE_CHANNEL=galaxy --dart-define-from-file=dart_defines.json
```

No Play Billing permission; paywall → community. Still **no** Tiger referral UI (`DeskKeyConfig.enabled` is web-only).
