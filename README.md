# Trade Master

Flutter-приложение для обучения криптотрейдингу: 47 уроков, paper trading, журнал сделок, реферальная система.

**Backend:** Supabase (auth, sync, premium) + Google Play / App Store IAP + Stripe (web).  
Подробная настройка: [docs/BACKEND_SETUP.md](docs/BACKEND_SETUP.md)  
**Быстрый старт Supabase (с нуля):** [docs/SUPABASE_QUICKSTART.md](docs/SUPABASE_QUICKSTART.md)

## Web-версия

Сайт: https://pavelcrypto70.github.io

### Локальная сборка

```bash
flutter pub get
flutter build web --release --no-web-resources-cdn
```

Локально после сборки:

```powershell
cd build\web
python -m http.server 7361
```

Открой http://127.0.0.1:7361

### Деплой на GitHub Pages

```powershell
.\tools\deploy_pages.ps1
```

## Генерация уроков

```bash
python tools/generate_curriculum_v2.py
python tools/gen_app_data.py
```

## Стек

- Flutter / Dart
- go_router, shared_preferences, url_launcher
- Локализация: EN, ES, PT, RU
