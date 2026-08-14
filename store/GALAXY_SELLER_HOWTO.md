# Samsung Seller Portal — куда тыкать (пошагово)

Открывай ссылки в браузере (Chrome / Edge). Аккаунт и документы — только ты.

---

## A. Зарегистрироваться (Seller)

### Шаг 1 — Samsung Account
1. Открой: https://account.samsung.com/
2. **Create account** / Create Samsung account
3. Почта, пароль, страна/регион  
   ⚠️ Страну потом в Seller Portal **нельзя сменить** — поставь ту, где реально будешь как продавец (не РФ, если цель «не РФ»).
4. Подтверди email кодом.

> Если почта Gmail/Yahoo — потом в Commercial Seller попросят **объяснить почему** публичный домен. Можно, но лучше свой домен если есть.

### Шаг 2 — Seller Portal (сайт магазина)
1. Открой: **https://seller.samsungapps.com/**
2. Справа вверху: **Sign Up Now** (синяя кнопка)
3. **Sign in with Samsung Account** — тем же аккаунтом
4. Пройди форму регистрации Seller Portal (имя, контакты, тип Private / Corporate)

Итог: ты внутри Seller Portal, но Android-приложения ещё нельзя заливать.

### Шаг 3 — Commercial Seller (обязательно для приложений)
Без этого **нельзя** публиковать Android-аппы (даже бесплатные).

Куда тыкать (любой из вариантов):
- После входа часто всплывает окно → **OK** → про D‑U‑N‑S  
- или справа вверху: **Request Corporate Commercial Seller**  
- или **Profile** (в шапке) → блок **Seller Status** → **Request Corporate Commercial Seller**

Что обычно просят:
- личность / данные как в паспорте (имя = как в документах)
- **PayPal** — самый простой способ «финансов» (даже если приложение бесплатное)
- страна банка/PayPal = стране профиля Seller
- документы **на английском** (или корейском для KR)
- если Gmail — коротко объяснить (например: “individual developer, app is free educational product”)

Ожидание: **несколько рабочих дней** (иногда до ~10 на проверку). Следи за email от Samsung.

Помощь внутри портала: **Help → Contact us → Contact us** (Customer Center).

---

## B. Когда одобрят — залить приложение

1. Зайди: https://seller.samsungapps.com/
2. **Add New App** / Register App → тип **Android**
3. Заполни вкладки примерно так:

| Поле | Что ставить |
|------|-------------|
| App title | Trade Master |
| Package name | `com.trademaster.education` |
| Free / Paid | **Free** |
| Category | Education (или Finance — что ближе по форме) |
| Binary | `build/galaxy_store/app-galaxy-release.aab` или `.apk` |
| Privacy Policy URL | `https://pavelcrypto70.github.io/privacy.html` |
| Support email | твой (например pavelcryptoclub@gmail.com) |
| Screenshots | из `store/assets/galaxy_screens/` |
| Description | из `store/GALAXY_STORE_LISTING.md` |

4. Страны дистрибуции — нужные (РФ можно не включать).
5. Age rating / content questionnaire — пройти.
6. **Submit** → ждать ревью (часто 1–7 дней).

⚠️ Заливай **galaxy**-сборку (без BILLING), не play.

---

## C. Готовые файлы у тебя в проекте

| Что | Путь |
|-----|------|
| AAB / APK | `build/galaxy_store/` |
| Описание EN+PT | `store/GALAXY_STORE_LISTING.md` |
| Скриншоты + иконка | `store/assets/galaxy_screens/` |
| Чеклист | `store/GALAXY_STORE_CHECKLIST.md` |
| Этот гайд | `store/GALAXY_SELLER_HOWTO.md` |

### Порядок скринов в листинге (рекомендуется)
1. `galaxy_01_home.png` — домашний экран + community  
2. `galaxy_02_lessons.png` — уроки / trial  
3. `galaxy_03_chart.png` — paper trading  
4. `galaxy_04_community.png` — CTA в Telegram  
5. `galaxy_icon_512.png` — иконка приложения в сторе  

> Это маркетинговые скрины в стиле приложения (телефона/эмулятора не было).  
> Позже лучше заменить 1–2 на реальные с Samsung после установки APK — ревью проходит спокойнее.
