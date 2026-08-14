# Play Data safety — Trade Master

## Collected
- Email — account sign-in (Supabase), linked to the user
- App activity / lesson progress / quiz scores — synced when signed in
- Purchase history — Play Billing / App Store IAP, verified on server
- Optional analytics (if enabled)

## Shared
- Not sold
- Google Play / Apple — purchase receipts
- Supabase — auth + progress
- Telegram — only if the user taps Desk Club (leaves the app)

## Security
- HTTPS in transit
- Delete account + export in Profile
- Restore purchases available

## Financial
Lifetime non-consumable IAP `trade_master_lifetime_full`. Not a broker. Education only.

## Children
Not directed at children.
