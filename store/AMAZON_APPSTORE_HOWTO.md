# Amazon Appstore — куда тыкать (пошагово)

Аккаунт **бесплатный**. PayPal для **бесплатного** приложения обычно **не нужен** — нужна верификация личности (паспорт/ID).

Сборка та же, что для Galaxy (без BILLING):  
`build/galaxy_store/app-galaxy-release.apk` или `.aab`

Описание / скрины — те же:
- `store/GALAXY_STORE_LISTING.md` (EN + PT)
- `store/assets/galaxy_screens/`

---

## A. Зарегистрировать аккаунт разработчика

1. Открой: **https://developer.amazon.com/**  
   или сразу консоль: **https://developer.amazon.com/dashboard**
2. **Sign In** (верх справа).
3. Можно войти аккаунтом **Amazon.com**, если есть; иначе создай.
4. При первом входе консоль предложит заполнить **Developer / Company Profile**:
   - Type: **Individual** (частное лицо)
   - Full legal name — **как в паспорте**, латиницей
   - Страна, адрес, телефон
   - Email поддержки: `pavelcryptoclub@gmail.com`
5. Прими Developer Agreement.

Плата за регистрацию: **$0**.

---

## B. Верификация личности (часто просят)

Если висит баннер **Identity Verification**:
1. **My Settings → Company Profile** — имя = как в ID.  
2. **Verify Identity** → паспорт / ID (фото спереди и сзади, если есть).  
3. Пока не подтвердят, новые сабмиты могут быть ограничены.

Это **не PayPal**. Без паспорта дальше часто не пустят.

---

## C. Добавить бесплатное приложение

1. Dashboard → виджет **Amazon Appstore** → **Add a New App**  
   (или Apps & Services → App List → Add New App)
2. Выбери **Android**
3. Заполни базово:

| Поле | Значение |
|------|----------|
| App title | Trade Master |
| Category | Education / Reference (что ближе) |
| Language | English (primary), PT если даёт |
| Free / Paid | **Free** |

4. Сохрани — откроется воркфлоу вкладок.

### Вкладки (зелёные галочки должны загореться)

**1. Upload Your App File**
- Залей `app-galaxy-release.apk` или `.aab`
- Target: Fire OS / Android devices (по умолчанию)
- Customer support email / phone
- Privacy Policy URL: `https://pavelcrypto70.github.io/privacy.html`

**2. Description**
- Копируй EN из `store/GALAXY_STORE_LISTING.md`
- Short + Full description
- Keywords: trading, crypto education, lessons, paper trading

**3. Images & Multimedia**
- Icon: `galaxy_icon_512.png`
- Screenshots (телефон): `galaxy_01` … `galaxy_04`
- Минимум обычно 3–4 скрина

**4. Availability & Pricing**
- Price: **Free**
- Страны: нужные (РФ можно не включать)

**5. Review & Submit**
- **Submit** → ждать ревью (часто от пары дней до ~1–2 недель)

⚠️ Не включай In-App Purchasing для этой сборки (у нас Galaxy/free без оплат).

---

## D. После публикации — воронка

В описании уже есть ссылка на Telegram.  
В приложении — CommunityBanner → `@Desk_Club`.

---

## Пересобрать APK (если нужно)

```powershell
powershell -ExecutionPolicy Bypass -File tools/build_galaxy.ps1
```

Артефакты: `build/galaxy_store/`

---

## Если упрёшься

- Баннер про ID → сначала Verify Identity  
- Спросят tax/payment → для **Free** можно отложить; выплаты нужны только для платных продаж  
- Вопросы: в консоли **… → Contact Us**

Когда откроется первый экран регистрации / Add App — кинь скрин, подскажу поля точечно.
