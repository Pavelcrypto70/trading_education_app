# Google Play — In-App Purchase

Product ID (must match exactly): **`trade_master_lifetime_full`**

## Steps in Play Console

1. [Google Play Console](https://play.google.com/console) → your app `com.trademaster.education`
2. **Monetize** → **Products** → **In-app products** → **Create product**
3. Product ID: `trade_master_lifetime_full`
4. Name: `Trade Master — Full Course (Lifetime)`
5. Description: `Lifetime access to all 47 lessons, paper trading, journal, certificate`
6. Price: set per country (e.g. $9.99 / 790 ₽ / R$29,90)
7. Status: **Active**

## License testing

1. **Setup** → **License testing** → add your Gmail
2. Install app via internal testing track
3. Purchase will be sandbox (no real charge)

## Verify in app

1. Sign in with Supabase email OTP
2. Profile → Premium → Buy
3. Complete Google Play purchase
4. Check Supabase → `user_profiles.is_premium = true`
