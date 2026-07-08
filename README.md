# Trade Master

Flutter-приложение для обучения криптотрейдингу: 47 уроков, paper trading, журнал сделок, реферальная система.

## Web-версия

Сайт: https://pavelcrypto70.github.io

### Локальная сборка

```bash
flutter pub get
flutter build web --release
```

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
- Локализация: RU, EN, PT
