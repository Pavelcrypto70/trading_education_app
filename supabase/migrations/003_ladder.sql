-- Desk Club ladder: public points board, cutoffs, closed chats membership.
-- Visible to everyone, no login needed. A row belongs to whoever knows its
-- device secret (only its sha256 is stored). Clients report their own totals;
-- ladder_upsert clamps growth to what the points engine allows:
-- 400 base points/day × streak multiplier 2 = 800 per day.

drop function if exists public.ladder_upsert_me(text, text, integer, integer, integer, boolean, boolean);
drop function if exists public.club_chat_members(text);

create table if not exists public.club_ladder (
  public_id text primary key,
  secret_hash text not null,
  user_id uuid references auth.users(id) on delete set null,
  display_name text not null default '',
  points integer not null default 0 check (points >= 0),
  week_points integer not null default 0 check (week_points >= 0),
  week_start date not null default date_trunc('week', now())::date,
  streak integer not null default 0 check (streak >= 0),
  students boolean not null default false,
  pro boolean not null default false,
  telegram text,
  last_seen timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  created_at timestamptz not null default now()
);

create index if not exists club_ladder_points_idx on public.club_ladder (points desc);
create index if not exists club_ladder_week_idx on public.club_ladder (week_start, week_points desc);

-- No direct table access: reads and writes only through the functions below,
-- so secret_hash never leaves the database.
alter table public.club_ladder enable row level security;
revoke all on public.club_ladder from anon, authenticated;

create or replace function public.ladder_upsert(
  p_public_id text,
  p_secret text,
  p_display_name text,
  p_points integer,
  p_week_points integer,
  p_streak integer,
  p_students boolean,
  p_pro boolean
) returns table (status text, points integer, rank_all bigint, rank_week bigint)
language plpgsql
security definer
set search_path = public
as $$
#variable_conflict use_column
declare
  v_week date := date_trunc('week', now())::date;
  v_hash text;
  v_prev public.club_ladder%rowtype;
  v_exists boolean;
  v_days integer;
  v_points integer;
  v_week_points integer;
  v_streak integer;
begin
  if p_public_id !~ '^TM-[0-9]{5}$' or length(coalesce(p_secret, '')) < 24 then
    return query select 'bad_request'::text, 0, null::bigint, null::bigint;
    return;
  end if;
  v_hash := encode(sha256(convert_to(p_secret, 'UTF8')), 'hex');

  select * into v_prev from public.club_ladder l where l.public_id = p_public_id;
  v_exists := found;

  if v_exists and v_prev.secret_hash <> v_hash then
    return query select 'id_taken'::text, 0, null::bigint, null::bigint;
    return;
  end if;

  if not v_exists then
    v_points := least(greatest(coalesce(p_points, 0), 0), 800);
    v_streak := least(greatest(coalesce(p_streak, 0), 0), 1);
  else
    v_days := greatest(1, (now()::date - v_prev.updated_at::date) + 1);
    v_points := greatest(v_prev.points,
      least(greatest(coalesce(p_points, 0), 0), v_prev.points + 800 * v_days, 20000));
    v_streak := least(greatest(coalesce(p_streak, 0), 0),
      v_prev.streak + v_days, (now()::date - v_prev.created_at::date) + 1);
  end if;

  v_week_points := least(greatest(coalesce(p_week_points, 0), 0), 5600, v_points);
  if v_exists and v_prev.week_start = v_week then
    v_week_points := least(greatest(v_prev.week_points, v_week_points),
      v_prev.week_points + 800 * v_days, v_points);
  end if;

  insert into public.club_ladder as l (
    public_id, secret_hash, user_id, display_name, points, week_points, week_start,
    streak, students, pro, last_seen, updated_at
  ) values (
    p_public_id, v_hash, auth.uid(),
    left(btrim(coalesce(p_display_name, '')), 24),
    v_points, v_week_points, v_week, v_streak,
    coalesce(p_students, false) and v_points >= 1400 and v_streak >= 7,
    coalesce(p_pro, false) and v_points >= 6900 and v_streak >= 30,
    now(), now()
  )
  on conflict (public_id) do update set
    user_id = coalesce(auth.uid(), l.user_id),
    display_name = excluded.display_name,
    points = excluded.points,
    week_points = excluded.week_points,
    week_start = excluded.week_start,
    streak = excluded.streak,
    students = l.students or excluded.students,
    pro = l.pro or excluded.pro,
    last_seen = now(),
    updated_at = now();

  return query
    select 'ok'::text,
      v_points,
      (select count(*) + 1 from public.club_ladder o where o.points > v_points),
      (select count(*) + 1 from public.club_ladder o
         where o.week_start = v_week and o.week_points > v_week_points);
end;
$$;

create or replace function public.ladder_top(p_period text, p_limit integer default 100)
returns table (
  rank bigint,
  public_id text,
  display_name text,
  points integer,
  telegram text,
  online boolean
)
language sql
security definer
set search_path = public
stable
as $$
  with scored as (
    select l.*,
      case when p_period = 'week' then
        case when l.week_start = date_trunc('week', now())::date then l.week_points else 0 end
      else l.points end as score
    from public.club_ladder l
  )
  select
    row_number() over (order by score desc, updated_at asc) as rank,
    public_id,
    display_name,
    score as points,
    telegram,
    last_seen > now() - interval '10 minutes' as online
  from scored
  where score > 0 or p_period <> 'week'
  order by rank
  limit least(greatest(p_limit, 1), 200);
$$;

-- Member list of a closed chat: only for someone who is in that chat.
create or replace function public.club_chat_members(p_chat text, p_public_id text, p_secret text)
returns table (
  rank bigint,
  public_id text,
  display_name text,
  points integer,
  telegram text,
  online boolean
)
language sql
security definer
set search_path = public
stable
as $$
  select
    row_number() over (order by l.points desc) as rank,
    l.public_id, l.display_name, l.points, l.telegram,
    l.last_seen > now() - interval '10 minutes' as online
  from public.club_ladder l
  where ((p_chat = 'pro' and l.pro) or (p_chat = 'students' and l.students))
    and exists (
      select 1 from public.club_ladder me
      where me.public_id = p_public_id
        and me.secret_hash = encode(sha256(convert_to(coalesce(p_secret, ''), 'UTF8')), 'hex')
        and ((p_chat = 'pro' and me.pro) or (p_chat = 'students' and me.students))
    )
  order by l.points desc
  limit 200;
$$;

revoke all on function public.ladder_upsert(text, text, text, integer, integer, integer, boolean, boolean) from public;
revoke all on function public.ladder_top(text, integer) from public;
revoke all on function public.club_chat_members(text, text, text) from public;
grant execute on function public.ladder_upsert(text, text, text, integer, integer, integer, boolean, boolean) to anon, authenticated;
grant execute on function public.ladder_top(text, integer) to anon, authenticated;
grant execute on function public.club_chat_members(text, text, text) to anon, authenticated;
