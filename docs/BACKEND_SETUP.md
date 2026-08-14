# Backend setup — Trade Master

Подключение Supabase + IAP + синхронизации прогресса.

## 1. Supabase проект

1. Создайте проект на [supabase.com](https://supabase.com)
2. SQL Editor → вставьте и выполните `supabase/migrations/001_initial_schema.sql`
3. Authentication → Providers → Email → включите **Email OTP**
4. Project Settings → API → скопируйте **URL** и **anon public key**

## 2. Edge Functions (покупки)

```bash
npm i -g supabase
supabase login
supabase link --project-ref YOUR_PROJECT_REF
supabase functions deploy verify-purchase
supabase functions deploy stripe-checkout   # опционально для web
supabase functions deploy stripe-webhook    # опционально для web
```

Secrets для Stripe (web-оплата):
```bash
supabase secrets set STRIPE_SECRET_KEY=sk_live_...
supabase secrets set STRIPE_PRICE_ID=price_...
supabase secrets set STRIPE_WEBHOOK_SECRET=whsec_...
supabase secrets set SITE_URL=https://pavelcrypto70.github.io
```

## 3. Flutter — локальная сборка

```powershell
$env:SUPABASE_URL="https://xxxx.supabase.co"
$env:SUPABASE_ANON_KEY="eyJhbG..."
flutter run -d chrome `
  --dart-define=SUPABASE_URL=$env:SUPABASE_URL `
  --dart-define=SUPABASE_ANON_KEY=$env:SUPABASE_ANON_KEY
```

## 4. GitHub Actions secrets

В репозитории `trading_education_app` → Settings → Secrets:

| Secret | Назначение |
|--------|------------|
| `SUPABASE_URL` | URL проекта |
| `SUPABASE_ANON_KEY` | Anon key |
| `PAGES_DEPLOY_TOKEN` | PAT с правом `repo` для деплоя на `.github.io` |

## 5. Google Play / App Store (IAP)

Product ID: `trade_master_lifetime_full` (см. `lib/config/app_config.dart`)

- **Google Play**: Monetize → Products → non-consumable, ID `trade_master_lifetime_full`
- **App Store**: App Store Connect → In-App Purchases → Non-Consumable

Android: `com.trademaster.education`  
Добавьте `BILLING` permission в AndroidManifest (in_app_purchase добавляет автоматически).

## 6. Что изменилось в приложении

| Было | Стало |
|------|-------|
| Локальный fake email auth | Supabase Email OTP |
| `setPremium(true)` на клиенте | Premium только с сервера (IAP / Stripe) |
| Прогресс только в SharedPreferences | Синхронизация в `user_progress` |
| Рефералы локально | RPC `redeem_referral_code` на сервере |
| Web bundle ~3.6MB + full JSON | Без `lessons_full.json`, tree-shake icons |

## 7. Деплой web

```powershell
$env:SUPABASE_URL="..."
$env:SUPABASE_ANON_KEY="..."
.\tools\deploy_pages.ps1
```

## 8. Проверка

1. Войти по email → получить OTP → ввести код
2. Пройти урок → выйти → войти снова → прогресс на месте
3. Купить premium (тест в sandbox) → `user_profiles.is_premium = true`
4. Попытка `setPremium` локально больше не открывает уроки
