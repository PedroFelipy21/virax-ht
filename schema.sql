-- ============ Grupo Virax · High Ticket — schema Supabase ============
-- Rode isto no Supabase: SQL Editor > New query > Run.

create extension if not exists "pgcrypto";

create table if not exists public.sales (
  id uuid primary key default gen_random_uuid(),
  data date not null,
  cliente text,
  instagram text,
  produto text,
  origem text,
  tipo text default 'TCV',
  valor numeric default 0,
  entrada numeric default 0,
  parcelas jsonb default '[]'::jsonb,
  residual jsonb default '{"valor":0,"aDecidir":false}'::jsonb,
  criado_em timestamptz default now()
);

create table if not exists public.config (
  id text primary key,
  metas jsonb default '{}'::jsonb
);

alter table public.sales  enable row level security;
alter table public.config enable row level security;

-- Leitura pública (qualquer visitante vê o painel; dado sensível? use allowlist também na leitura)
drop policy if exists sales_read  on public.sales;
drop policy if exists config_read on public.config;
create policy sales_read  on public.sales  for select using (true);
create policy config_read on public.config for select using (true);

-- Escrita só para gestão (e-mails autorizados). Edite a lista abaixo:
drop policy if exists sales_write  on public.sales;
drop policy if exists config_write on public.config;
create policy sales_write on public.sales for all to authenticated
  using ( (auth.jwt() ->> 'email') in ('pedrfelipy12@gmail.com') )
  with check ( (auth.jwt() ->> 'email') in ('pedrfelipy12@gmail.com') );
create policy config_write on public.config for all to authenticated
  using ( (auth.jwt() ->> 'email') in ('pedrfelipy12@gmail.com') )
  with check ( (auth.jwt() ->> 'email') in ('pedrfelipy12@gmail.com') );

-- Realtime
alter publication supabase_realtime add table public.sales;
alter publication supabase_realtime add table public.config;

-- Linha de config inicial
insert into public.config (id, metas) values ('app', '{}'::jsonb)
  on conflict (id) do nothing;
