# Huawei AppGallery — ссылки и данные для заливки

Тип: **бесплатное** приложение (без IAP).  
Сборка: `build/galaxy_store/app-galaxy-release.apk` (или `.aab`)  
Оплата / PayPal для free обычно **не нужны** — нужна **верификация личности**.

---

## Главные ссылки

| Что | URL |
|-----|-----|
| Регистрация HUAWEI ID | https://developer.huawei.com/consumer/en/ |
| Документация: Register + Verify | https://developer.huawei.com/consumer/en/doc/start/registration-and-verification-0000001053628148 |
| **AppGallery Connect** (сюда заливать) | https://developer.huawei.com/consumer/en/service/josp/agc/index.html |
| Новичкам | https://developer.huawei.com/consumer/en/develop-novice-guide/ |
| AppGallery overview | https://developer.huawei.com/consumer/en/appgallery/ |

Прямой вход в консоль: часто редирект на  
https://appgallery.huawei.com / AppGallery Connect после Sign in.

---

## A. Регистрация (по шагам)

### 1. HUAWEI ID
1. https://developer.huawei.com/consumer/en/  
2. Справа сверху **Sign in** → **Register**  
3. Почта (можно `pavelcryptoclub@gmail.com`) + пароль + код из письма  

### 2. Тип разработчика
Выбери **Individual** / Individual developer (не Enterprise).

### 3. Identity verification
Загрузи паспорт / ID (как попросит форма).  
Имя = как в документе.  
Жди **1–3 рабочих дня** (письмо на почту).

Пока не окнут верификацию — полноценно публиковать нельзя.

---

## B. Создать приложение в AppGallery Connect

1. Зайди: https://developer.huawei.com/consumer/en/service/josp/agc/index.html  
2. **My apps** → **New** / Create  
3. Тип: **APK** (Android) / App (не Harmony-only, если дают выбор)  
4. Package name: **`com.trademaster.education`**  
5. Default language: **English**

---

## C. Данные для копипаста

### Название
```
Trade Master
```
или
```
Trade Master — Learn Trading
```

### Category
```
Education
```
(или Tools / Finance — что ближе в списке)

### Short description (EN)
```
47 trading lessons, paper trading, quizzes & Telegram community. Free trial inside.
```

### Full description (EN)
```
Trade Master is a structured crypto trading education app — from the basics to confident paper trading.

What's inside:
• 47 structured lessons (English & Portuguese; Russian available in app)
• Paper trading on realistic charts
• Trade journal and learning plan
• Quizzes, flashcards, daily challenge
• 30-day learning path
• Course certificate after completion
• Live Telegram trader community

This free build includes trial lessons. Join the community for full-course discussion, homework help, and live Q&A:
https://t.me/Desk_Club

Educational product only. Not financial advice. Trading involves risk.
```

### Short (PT) — если есть поле
```
47 aulas de trading, paper trading, quizzes e comunidade no Telegram. Trial grátis.
```

### Контакты / Policy
| Поле | Значение |
|------|----------|
| Package | `com.trademaster.education` |
| Free / Paid | **Free** |
| Privacy Policy | `https://pavelcrypto70.github.io/privacy.html` |
| Support email | `pavelcryptoclub@gmail.com` |
| Community | `https://t.me/Desk_Club` |
| Website (если есть) | `https://pavelcrypto70.github.io` |

### Файлы
| Что | Путь |
|-----|------|
| APK / AAB | `build/galaxy_store/app-galaxy-release.apk` |
| Icon 512 | `store/assets/galaxy_screens/galaxy_icon_512.png` |
| Screenshots | `store/assets/galaxy_screens/galaxy_01_home.png` … `galaxy_04_community.png` |

Полные тексты ещё в: `store/GALAXY_STORE_LISTING.md`

---

## D. Страны

- Распространение: выбери нужные (РФ можно не включать).  
- Если в профиле разработчика нет Russia — ставь **страну, где реально живёшь** и где проходит ID (как с Amazon).  
Страна аккаунта ≠ обязательный список стран магазина.

---

## E. Submit

Заполни все обязательные (*) → загрузи APK → **Submit** / Release.  
Ревью: обычно несколько дней.

**Merchant / IAP** не включай — приложение бесплатное без покупок.

---

## Если откажут / попросят bank card
Для Individual иногда просят карту для real-name (особенно CN).  
Для международной free-публикации чаще хватает паспорта.  
Не включай платные сервисы — меньше вопросов к банку/PayPal.

---

## Старт прямо сейчас
1. https://developer.huawei.com/consumer/en/ → **Sign in / Register**  
2. Individual + Verify ID  
3. Потом AppGallery Connect → New app  

Скрин следующего экрана — подскажу куда тыкать дальше.
