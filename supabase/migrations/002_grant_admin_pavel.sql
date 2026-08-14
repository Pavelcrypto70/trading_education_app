-- Grant full admin + premium to owner account (run in Supabase SQL Editor).
update public.user_profiles
set
  is_admin = true,
  is_premium = true,
  updated_at = now()
where lower(email) = lower('pavelcryptoclub@gmail.com');
