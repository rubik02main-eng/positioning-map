-- People Positioning Map: 端末間の同期用テーブル
-- Supabase の SQL Editor に貼り付けて、1回だけ実行する。
-- 1人1行。自分の行だけ読み書きできる(行レベルセキュリティ)。

create table if not exists public.people_map (
  user_id    uuid primary key references auth.users(id) on delete cascade,
  data       jsonb not null,
  updated_at timestamptz not null default now()
);

alter table public.people_map enable row level security;

create policy "own row select" on public.people_map
  for select using (auth.uid() = user_id);
create policy "own row insert" on public.people_map
  for insert with check (auth.uid() = user_id);
create policy "own row update" on public.people_map
  for update using (auth.uid() = user_id) with check (auth.uid() = user_id);
