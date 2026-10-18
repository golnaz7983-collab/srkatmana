-- Bina game database schema. RLS is enabled on every public table.
create table if not exists public.bina_properties (
 id text primary key, code text not null unique, data jsonb not null default '{}'::jsonb,
 for_sale boolean not null default false, created_at timestamptz not null default now()
);
create table if not exists public.bina_purchase_requests (
 id text primary key, property_id text not null, data jsonb not null default '{}'::jsonb,
 status text not null default 'در انتظار بررسی', created_at timestamptz not null default now()
);
create table if not exists public.bina_sale_requests (
 id text primary key, property_id text not null, data jsonb not null default '{}'::jsonb,
 status text not null default 'در انتظار بررسی', created_at timestamptz not null default now()
);
create table if not exists public.bina_owner_history (
 id text primary key, data jsonb not null default '{}'::jsonb, created_at timestamptz not null default now()
);
alter table public.bina_properties enable row level security;
alter table public.bina_purchase_requests enable row level security;
alter table public.bina_sale_requests enable row level security;
alter table public.bina_owner_history enable row level security;
drop policy if exists "Public can read game properties" on public.bina_properties;
create policy "Public can read game properties" on public.bina_properties for select to anon, authenticated using (true);
drop policy if exists "Admins can insert properties" on public.bina_properties;
create policy "Admins can insert properties" on public.bina_properties for insert to authenticated with check ((select auth.jwt()->'app_metadata'->>'role') = 'admin');
drop policy if exists "Admins can update properties" on public.bina_properties;
create policy "Admins can update properties" on public.bina_properties for update to authenticated using ((select auth.jwt()->'app_metadata'->>'role') = 'admin') with check ((select auth.jwt()->'app_metadata'->>'role') = 'admin');
drop policy if exists "Admins can delete properties" on public.bina_properties;
create policy "Admins can delete properties" on public.bina_properties for delete to authenticated using ((select auth.jwt()->'app_metadata'->>'role') = 'admin');
drop policy if exists "Anyone can submit purchase requests" on public.bina_purchase_requests;
create policy "Anyone can submit purchase requests" on public.bina_purchase_requests for insert to anon, authenticated with check (true);
drop policy if exists "Admins can read purchase requests" on public.bina_purchase_requests;
create policy "Admins can read purchase requests" on public.bina_purchase_requests for select to authenticated using ((select auth.jwt()->'app_metadata'->>'role') = 'admin');
drop policy if exists "Admins can update purchase requests" on public.bina_purchase_requests;
create policy "Admins can update purchase requests" on public.bina_purchase_requests for update to authenticated using ((select auth.jwt()->'app_metadata'->>'role') = 'admin') with check ((select auth.jwt()->'app_metadata'->>'role') = 'admin');
drop policy if exists "Anyone can submit sale requests" on public.bina_sale_requests;
create policy "Anyone can submit sale requests" on public.bina_sale_requests for insert to anon, authenticated with check (true);
drop policy if exists "Admins can read sale requests" on public.bina_sale_requests;
create policy "Admins can read sale requests" on public.bina_sale_requests for select to authenticated using ((select auth.jwt()->'app_metadata'->>'role') = 'admin');
drop policy if exists "Admins can update sale requests" on public.bina_sale_requests;
create policy "Admins can update sale requests" on public.bina_sale_requests for update to authenticated using ((select auth.jwt()->'app_metadata'->>'role') = 'admin') with check ((select auth.jwt()->'app_metadata'->>'role') = 'admin');
drop policy if exists "Admins can read ownership history" on public.bina_owner_history;
create policy "Admins can read ownership history" on public.bina_owner_history for select to authenticated using ((select auth.jwt()->'app_metadata'->>'role') = 'admin');
drop policy if exists "Admins can write ownership history" on public.bina_owner_history;
create policy "Admins can write ownership history" on public.bina_owner_history for all to authenticated using ((select auth.jwt()->'app_metadata'->>'role') = 'admin') with check ((select auth.jwt()->'app_metadata'->>'role') = 'admin');
grant select on public.bina_properties to anon, authenticated;
grant select, insert, update, delete on public.bina_properties to authenticated;
grant insert on public.bina_purchase_requests, public.bina_sale_requests to anon, authenticated;
grant select, insert, update on public.bina_purchase_requests, public.bina_sale_requests to authenticated;
grant select, insert, update, delete on public.bina_owner_history to authenticated;
