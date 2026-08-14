# App Store — In-App Purchase

Product ID: **`trade_master_lifetime_full`**

## App Store Connect

1. [App Store Connect](https://appstoreconnect.apple.com) → your app
2. **Features** → **In-App Purchases** → **+**
3. Type: **Non-Consumable**
4. Reference Name: `Lifetime Full Course`
5. Product ID: `trade_master_lifetime_full`
6. Price: Tier matching ~$9.99
7. Submit for review with app binary

## Local testing (StoreKit)

1. Open `ios/Runner.xcworkspace` in Xcode
2. **Product** → **Scheme** → **Edit Scheme** → **Run** → **Options**
3. StoreKit Configuration: select `TradeMaster.storekit`
4. Run on simulator — purchases work without App Store Connect

## Sandbox tester

1. **Users and Access** → **Sandbox** → **Testers** → add Apple ID
2. On device: Settings → App Store → Sandbox Account
3. Sign in with sandbox Apple ID before testing purchase
