# Galaxy Store — чеклист публикации (бесплатная сборка без оплат)

Цель: фри-приложение → люди пробуют уроки → проваливаются в Telegram `@Desk_Club`.

Обычная Play/веб-сборка **с оплатами не трогаем**. Galaxy собирается отдельно.

---

## 0. Что уже сделано в проекте

- Flavor **`play`** — с биллингом (как раньше, по умолчанию).
- Flavor **`galaxy`** — без permission `BILLING`.
- Флаг **`ENABLE_BILLING=false`** — кнопки «Купить / Восстановить» скрыты, paywall ведёт в сообщество.
- Код оплат в `lib/services/purchase_service.dart` **сохранён** (для play просто не вызывается на galaxy).

---

## 1. Аккаунт Samsung Seller Portal

1. Создать [Samsung Account](https://account.samsung.com/).
2. Зарегистрироваться в [Seller Portal](https://seller.samsungapps.com/).
3. Подать заявку на **Commercial Seller** (нужна для Android-приложений).
4. Дождаться одобрения (часто несколько рабочих дней; могут спросить документы / PayPal / банк).
5. Плата за регистрацию / год — **нет**.

---

## 2. Прогреть Telegram `@Desk_Club`

Готовые тексты: [`TELEGRAM_SEED_POSTS.md`](TELEGRAM_SEED_POSTS.md) — скопировать вручную в чат (закреп + 5–6 сообщений).

---

## 3. Собрать Galaxy APK/AAB (без оплат)

В корне проекта:

```powershell
powershell -ExecutionPolicy Bypass -File tools/build_galaxy.ps1
```

Скрипт копирует проект в `C:\dev\tea_galaxy` (ASCII-путь — иначе Windows ломает release-сборку из‑за кириллицы в `Users\Павел`) и кладёт артефакты сюда:

- `build/galaxy_store/app-galaxy-release.aab`
- `build/galaxy_store/app-galaxy-release.apk`

### Play-сборка (сохранённая, с оплатами)

```powershell
flutter build appbundle --flavor play --release `
  --dart-define=ENABLE_BILLING=true `
  --dart-define=STORE_CHANNEL=play
```
(из ASCII-копии `C:\dev\tea_galaxy`, если в домашнем пути есть кириллица)

---

## 4. Перед загрузкой (обязательно проверить)

- [ ] На устройстве Samsung: `flutter run --flavor galaxy --dart-define=ENABLE_BILLING=false --dart-define=STORE_CHANNEL=galaxy`
- [ ] Нет экранов покупки / Restore / цен
- [ ] Paywall на закрытом уроке → «Открыть Telegram-чат»
- [ ] CommunityBanner на домашнем экране открывает `@Desk_Club`
- [ ] Trial-уроки 1, 2, 3, 7, 10 открываются
- [ ] Чат уже не пустой (закреп + несколько живых сообщений)
- [ ] Privacy Policy URL (публичная страница) — Samsung часто требует
- [ ] Иконка 512×512, скриншоты телефонов (минимум по гайду Seller Portal)
- [ ] **Release-подпись**: сейчас в gradle для release ещё debug-ключ. Перед продом сделайте свой keystore (один раз сохранить!).

---

## 4. Залить в Seller Portal

1. Seller Portal → **Add New App** → Android.
2. Package name: `com.trademaster.education`
3. Тип: **Free**.
4. Категория: Education / Finance (что ближе по смыслу).
5. Описание: обучение трейдингу + community в Telegram (без обещаний «гарантированный профит»).
6. Binary: загрузить AAB или APK (galaxyRelease).
7. Страны: нужные (не РФ можно не включать, если не хотите).
8. Content rating / возрастной рейтинг — пройти опрос.
9. Submit → ждать ревью (часто 1–7 дней).

---

## 5. После публикации — «чтобы было живо»

1. В описании стора и в первом экране приложения — явный путь в Telegram.
2. В чате: ежедневный пост / опрос / «кто на каком уроке».
3. Смотреть: сколько установок → сколько вступлений в `@Desk_Club`.

---

## 6. Не смешивать

| Сборка | Flavor | BILLING | Оплаты в UI |
|--------|--------|---------|-------------|
| Google Play / полный | `play` | да | да |
| Galaxy Store | `galaxy` | нет | нет → community |

Не заливайте `play`-сборку в Galaxy Store.
