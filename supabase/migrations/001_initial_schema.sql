-- Trade Master backend: auth profiles, progress sync, purchases, referrals.
-- Run in Supabase SQL Editor or via `supabase db push`.

-- ── Profiles (premium/admin controlled server-side) ─────────────────────────
create table if not exists public.user_profiles (
  id uuid primary key references auth.users (id) on delete cascade,
  email text,
  display_name text,
  is_premium boolean not null default false,
  is_admin boolean not null default false,
  referral_code text unique,
  referred_by text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- ── Progress blob (client sync, no premium flag here) ───────────────────────
create table if not exists public.user_progress (
  user_id uuid primary key references auth.users (id) on delete cascade,
  data jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

-- ── Verified purchases ──────────────────────────────────────────────────────
create table if not exists public.purchases (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  product_id text not null,
  platform text not null,
  transaction_id text not null unique,
  receipt_data text,
  verified_at timestamptz not null default now()
);

create index if not exists purchases_user_id_idx on public.purchases (user_id);

-- ── Referral redemptions (one per user) ───────────────────────────────────────
create table if not exists public.referral_redemptions (
  id uuid primary key default gen_random_uuid(),
  redeemer_id uuid not null references auth.users (id) on delete cascade unique,
  referral_code text not null,
  created_at timestamptz not null default now()
);

create index if not exists referral_redemptions_code_idx
  on public.referral_redemptions (referral_code);

-- ── Auto-create profile on signup ─────────────────────────────────────────────
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  admin_emails text[] := array['pavelcryptoclub@gmail.com'];
begin
  insert into public.user_profiles (id, email, display_name, is_admin)
  values (
    new.id,
    new.email,
    coalesce(new.raw_user_meta_data->>'display_name', split_part(new.email, '@', 1)),
    lower(new.email) = any (select lower(unnest(admin_emails)))
  );
  insert into public.user_progress (user_id) values (new.id);
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- ── Referral code generator ───────────────────────────────────────────────────
create or replace function public.ensure_referral_code()
returns text
language plpgsql
security definer
set search_path = public
as $$
declare
  code text;
  uid uuid := auth.uid();
begin
  if uid is null then
    return null;
  end if;
  select referral_code into code from public.user_profiles where id = uid;
  if code is not null then
    return code;
  end if;
  loop
    code := 'TM-' || upper(substr(md5(random()::text || clock_timestamp()::text), 1, 6));
    exit when not exists (select 1 from public.user_profiles where referral_code = code);
  end loop;
  update public.user_profiles set referral_code = code, updated_at = now() where id = uid;
  return code;
end;
$$;

-- ── Redeem referral (server-side, one per user) ─────────────────────────────
create or replace function public.redeem_referral_code(p_code text)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  uid uuid := auth.uid();
  normalized text := upper(trim(p_code));
  owner_id uuid;
begin
  if uid is null then
    return jsonb_build_object('ok', false, 'error', 'not_authenticated');
  end if;
  if normalized is null or normalized = '' then
    return jsonb_build_object('ok', false, 'error', 'empty');
  end if;
  if not normalized like 'TM-%' then
    return jsonb_build_object('ok', false, 'error', 'invalid');
  end if;
  if exists (select 1 from public.referral_redemptions where redeemer_id = uid) then
    return jsonb_build_object('ok', false, 'error', 'already');
  end if;
  select id into owner_id from public.user_profiles where referral_code = normalized;
  if owner_id is null then
    return jsonb_build_object('ok', false, 'error', 'not_found');
  end if;
  if owner_id = uid then
    return jsonb_build_object('ok', false, 'error', 'own');
  end if;
  insert into public.referral_redemptions (redeemer_id, referral_code)
  values (uid, normalized);
  update public.user_profiles
  set referred_by = normalized, updated_at = now()
  where id = uid and referred_by is null;
  return jsonb_build_object('ok', true);
end;
$$;

-- ── Grant premium after verified purchase (service role / edge function only) ─
create or replace function public.grant_premium_from_purchase(
  p_user_id uuid,
  p_product_id text,
  p_platform text,
  p_transaction_id text,
  p_receipt_data text default null
)
returns boolean
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.purchases (user_id, product_id, platform, transaction_id, receipt_data)
  values (p_user_id, p_product_id, p_platform, p_transaction_id, p_receipt_data)
  on conflict (transaction_id) do nothing;

  update public.user_profiles
  set is_premium = true, updated_at = now()
  where id = p_user_id;

  return true;
end;
$$;

-- ── RLS ───────────────────────────────────────────────────────────────────────
alter table public.user_profiles enable row level security;
alter table public.user_progress enable row level security;
alter table public.purchases enable row level security;
alter table public.referral_redemptions enable row level security;

create policy "profiles_select_own"
  on public.user_profiles for select
  using (auth.uid() = id);

-- Users may update display_name only; premium/admin immutable from client.
create policy "profiles_update_own_safe"
  on public.user_profiles for update
  using (auth.uid() = id)
  with check (
    is_premium = (select p.is_premium from public.user_profiles p where p.id = auth.uid())
    and is_admin = (select p.is_admin from public.user_profiles p where p.id = auth.uid())
    and referral_code = (select p.referral_code from public.user_profiles p where p.id = auth.uid())
  );

create policy "progress_select_own"
  on public.user_progress for select
  using (auth.uid() = user_id);

create policy "progress_upsert_own"
  on public.user_progress for insert
  with check (auth.uid() = user_id);

create policy "progress_update_own"
  on public.user_progress for update
  using (auth.uid() = user_id);

create policy "purchases_select_own"
  on public.purchases for select
  using (auth.uid() = user_id);

create policy "referrals_select_own"
  on public.referral_redemptions for select
  using (auth.uid() = redeemer_id);
