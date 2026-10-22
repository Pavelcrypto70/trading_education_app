-- Desk Club key: a learner registers on Tiger.com through our link and sends
-- their Tiger User ID. The owner checks it in the partner cabinet and approves.
-- Approval sets user_profiles.is_premium, which already opens lessons 15–58.
-- One Tiger User ID = one account. The UID is visible only to its owner and admins.
--
-- Owner queue (SQL editor or bot):
--   select * from public.desk_key_queue();
--   select public.desk_key_review('<request id>', true);
--   select public.desk_key_review('<request id>', false, 'аккаунт создан не по ссылке');

create table if not exists public.ref_verifications (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  public_id text,
  tiger_uid text not null,
  status text not null default 'pending' check (status in ('pending', 'approved', 'rejected')),
  reason text,
  reviewer uuid references auth.users (id) on delete set null,
  created_at timestamptz not null default now(),
  reviewed_at timestamptz
);

create index if not exists ref_verifications_user_idx on public.ref_verifications (user_id, created_at desc);
create unique index if not exists ref_verifications_uid_approved_idx
  on public.ref_verifications (tiger_uid) where status = 'approved';

alter table public.ref_verifications enable row level security;
revoke all on public.ref_verifications from anon, authenticated;

create or replace function public.desk_key_submit(p_uid text, p_public_id text default null)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_user uuid := auth.uid();
  v_uid text := regexp_replace(coalesce(p_uid, ''), '\s', '', 'g');
begin
  if v_user is null then
    return jsonb_build_object('ok', false, 'error', 'not_authenticated');
  end if;
  if v_uid !~ '^[0-9A-Za-z]{5,20}$' then
    return jsonb_build_object('ok', false, 'error', 'invalid');
  end if;
  if exists (
    select 1 from public.ref_verifications
    where tiger_uid = v_uid and status = 'approved' and user_id <> v_user
  ) then
    return jsonb_build_object('ok', false, 'error', 'taken');
  end if;
  -- Re-sending replaces the open request instead of piling up duplicates.
  delete from public.ref_verifications where user_id = v_user and status = 'pending';
  insert into public.ref_verifications (user_id, public_id, tiger_uid)
  values (v_user, nullif(p_public_id, ''), v_uid);
  return jsonb_build_object('ok', true, 'status', 'pending');
end;
$$;

create or replace function public.desk_key_status()
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_user uuid := auth.uid();
  v_row public.ref_verifications%rowtype;
  v_rejections integer;
begin
  if v_user is null then
    return jsonb_build_object('status', 'none');
  end if;
  select * into v_row from public.ref_verifications
  where user_id = v_user order by created_at desc limit 1;
  select count(*) into v_rejections from public.ref_verifications
  where user_id = v_user and status = 'rejected';
  if v_row.id is null then
    return jsonb_build_object('status', 'none', 'rejections', v_rejections);
  end if;
  return jsonb_build_object('status', v_row.status, 'reason', v_row.reason, 'rejections', v_rejections);
end;
$$;

create or replace function public.desk_key_queue()
returns setof public.ref_verifications
language plpgsql
security definer
set search_path = public
as $$
begin
  if not exists (select 1 from public.user_profiles where id = auth.uid() and is_admin) then
    raise exception 'admin only';
  end if;
  return query select * from public.ref_verifications where status = 'pending' order by created_at;
end;
$$;

create or replace function public.desk_key_review(p_id uuid, p_approve boolean, p_reason text default null)
returns boolean
language plpgsql
security definer
set search_path = public
as $$
declare
  v_user uuid;
begin
  -- Service role (SQL editor, bot) has no auth.uid(); app users must be admins.
  if auth.uid() is not null
     and not exists (select 1 from public.user_profiles where id = auth.uid() and is_admin) then
    raise exception 'admin only';
  end if;
  update public.ref_verifications
  set status = case when p_approve then 'approved' else 'rejected' end,
      reason = case when p_approve then null else p_reason end,
      reviewer = auth.uid(),
      reviewed_at = now()
  where id = p_id and status = 'pending'
  returning user_id into v_user;
  if v_user is null then
    return false;
  end if;
  if p_approve then
    update public.user_profiles set is_premium = true, updated_at = now() where id = v_user;
  end if;
  return true;
end;
$$;

revoke all on function public.desk_key_review(uuid, boolean, text) from anon;
revoke all on function public.desk_key_queue() from anon;
revoke all on function public.desk_key_submit(text, text) from anon;
revoke all on function public.desk_key_status() from anon;
