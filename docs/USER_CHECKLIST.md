# Что сделать тебе — Trade Master

Пошаговый чеклист после автоматической настройки.

## Срочно (безопасность)

- [ ] **Перевыпусти токены**, если отправлял в чат:
  - GitHub PAT → обнови `PAGES_DEPLOY_TOKEN` в [Secrets](https://github.com/Pavelcrypto70/trading_education_app/settings/secrets/actions)
  - Supabase `sbp_...` → обнови `SUPABASE_ACCESS_TOKEN`
- [ ] Удали старые токены в дашбордах

## Google Play (1–2 дня)

1. [Google Play Console](https://play.google.com/console) → Create app → `Trade Master`
2. Package: `com.trademaster.education`
3. **Monetize → Products** → Non-consumable → ID: `trade_master_lifetime_full`, цена 990₽
4. **Setup → API access** → Service Account → JSON ключ
5. Supabase → **Edge Functions → Secrets**:
   ```
   GOOGLE_PLAY_SERVICE_ACCOUNT_JSON = <весь JSON файл>
   ```
6. Redeploy function:
   ```powershell
   $env:SUPABASE_ACCESS_TOKEN="sbp_..."
   .\tools\deploy_supabase_functions.ps1
   ```
7. Internal testing → добавь 5 Gmail тестеров
8. Загрузи AAB:
   ```powershell
   flutter build appbundle --dart-define-from-file=dart_defines.json
   ```
   Файл: `build/app/outputs/bundle/release/app-release.aab`

Тексты для листинга: [store/PLAY_STORE_LISTING.md](store/PLAY_STORE_LISTING.md)

## App Store (опционально, +$99/год)

1. [App Store Connect](https://appstoreconnect.apple.com)
2. In-App Purchase: `trade_master_lifetime_full` (Non-Consumable)
3. Supabase secret: `APPLE_SHARED_SECRET` = из App Store Connect
4. Sandbox tester → тест на устройстве
5. `ios/TradeMaster.storekit` уже есть для локального теста в Xcode

## Analytics PostHog (15 мин, бесплатно)

1. [posthog.com](https://posthog.com) → проект → Project API Key
2. Добавь в `dart_defines.json`:
   ```json
   "POSTHOG_API_KEY": "phc_..."
   ```
3. Пересобери web: `.\tools\deploy_pages.ps1`

События уже в коде: `sign_up`, `lesson_complete`, `paywall_view`, `purchase_start`, `purchase_success`, `day_7_return`

## Stripe для web-оплаты (опционально)

1. [stripe.com](https://stripe.com) → Product → Price $9.99
2. Supabase secrets:
   - `STRIPE_SECRET_KEY`
   - `STRIPE_PRICE_ID`
   - `STRIPE_WEBHOOK_SECRET`
   - `SITE_URL=https://pavelcrypto70.github.io`
3. Stripe Dashboard → Webhooks → `https://akwiexmyblpuckvbqjsd.supabase.co/functions/v1/stripe-webhook`

## Маркетинг (еженедельно)

- [ ] 3 Shorts/Reels в неделю → ссылка на https://pavelcrypto70.github.io
- [ ] Пост в Telegram `@Desk_Club`
- [ ] Попросить 5 друзей пройти trial и дать feedback
- [ ] Цель: **10 платящих** в первый месяц

## Проверка что всё работает

```powershell
flutter run -d chrome --dart-define-from-file=dart_defines.json
```

1. Профиль → Войти → OTP
2. Home → «День X из 30»
3. Урок → завершить → прогресс синхронизируется
4. Paywall на уроке 11+
5. Privacy / Terms в Профиле
6. Сертификат — чеклист требований

## CI/CD

Push в `main` → автоматически:
- **Deploy to GitHub Pages**
- **Deploy Supabase Edge Functions** (при изменении `supabase/functions/`)

Ручной запуск: GitHub → Actions → Run workflow

---

Вопросы: pavelcryptoclub@gmail.com
