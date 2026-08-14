# Быстрый старт Supabase (15 минут)

Сделайте эти шаги один раз — после этого всё остальное автоматизировано.

## Шаг 1. Создать проект

1. Откройте https://supabase.com/dashboard
2. Войдите через GitHub (удобно, раз репо уже на GitHub)
3. **New project**
   - Name: `trade-master`
   - Database password: придумайте и **сохраните**
   - Region: `Southeast Asia (Singapore)` — ближе к вам (UTC+7)
4. Нажмите **Create** → подождите ~2 минуты

## Шаг 2. Применить схему БД

1. В левом меню: **SQL Editor** → **New query**
2. Откройте файл `supabase/migrations/001_initial_schema.sql` в этом репозитории
3. Скопируйте **весь** SQL → вставьте в редактор → **Run**
4. Должно быть: `Success. No rows returned`

## Шаг 3. Включить вход по email + URL редиректа (важно!)

1. **Authentication** → **Providers** → **Email**
2. Включите **Enable Email provider**
3. **Confirm email** — можно выключить (мы используем OTP-код)
4. **Save**

5. **Authentication** → **URL Configuration** (или Auth → Settings):
   - **Site URL:** `https://pavelcrypto70.github.io`
   - **Redirect URLs** (добавьте все):
     - `https://pavelcrypto70.github.io`
     - `https://pavelcrypto70.github.io/**`
     - `http://localhost:8080/**` (только для локальной отладки Flutter web)

⚠️ Если Site URL оставить `http://localhost:3000`, ссылка из письма откроет localhost и будет `ERR_CONNECTION_REFUSED`.

6. **Save**

## Шаг 4. Скопировать ключи

1. **Project Settings** (шестерёнка) → **API**
2. Скопируйте:
   - **Project URL** → например `https://abcdefgh.supabase.co`
   - **anon public** key → длинная строка `eyJ...`

## Шаг 5. Вставить ключи в проект

Скопируйте `dart_defines.example.json` → `dart_defines.json`:

```powershell
Copy-Item dart_defines.example.json dart_defines.json
notepad dart_defines.json
```

Замените `YOUR_PROJECT` и `YOUR_ANON_KEY` на реальные значения. Сохраните.

## Шаг 6. Задеплоить Edge Functions

В терминале в корне проекта:

```powershell
npm install
npx supabase login
npx supabase link --project-ref ВАШ_REF
```

`ВАШ_REF` — это часть URL дашборда:  
`https://supabase.com/dashboard/project/`**`abcdefghij`**`/...`

```powershell
npx supabase functions deploy verify-purchase
npx supabase functions deploy stripe-checkout
npx supabase functions deploy stripe-webhook
```

## Шаг 7. GitHub Secrets (для авто-деплоя)

Репозиторий https://github.com/Pavelcrypto70/trading_education_app  
→ **Settings** → **Secrets and variables** → **Actions** → **New repository secret**

| Name | Value |
|------|-------|
| `SUPABASE_URL` | `https://akwiexmyblpuckvbqjsd.supabase.co` |
| `SUPABASE_ANON_KEY` | из `dart_defines.json` |
| `SUPABASE_PROJECT_REF` | `akwiexmyblpuckvbqjsd` |
| `SUPABASE_ACCESS_TOKEN` | [создать](https://supabase.com/dashboard/account/tokens) |
| `PAGES_DEPLOY_TOKEN` | [GitHub PAT](https://github.com/settings/tokens/new?scopes=repo) |

Полная таблица: [tools/GITHUB_SECRETS_VALUES.md](../tools/GITHUB_SECRETS_VALUES.md)

После secrets: **Actions** → **Deploy Supabase Edge Functions** → **Run workflow**

Локально:
```powershell
$env:SUPABASE_ACCESS_TOKEN="sbp_..."
.\tools\deploy_supabase_functions.ps1
```

## Шаг 8. Проверка

```powershell
flutter run -d chrome --dart-define-from-file=dart_defines.json
```

1. Профиль → Войти → email → код из письма
2. Пройти урок → выйти → войти снова → прогресс сохранился

---

**Или одной командой после шагов 1–5:**

```powershell
.\tools\setup_backend.ps1
```

Когда проект создан — пришлите в чат **Project URL** и **anon key**, я вставлю их в `dart_defines.json` и задеплою web с облаком.
