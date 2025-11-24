-- Create profiles table
create table public.profiles (
  id uuid not null references auth.users on delete cascade,
  email text,
  created_at timestamp with time zone default now(),
  primary key (id)
);

alter table public.profiles enable row level security;

-- Profiles policies
create policy "Users can view own profile"
  on public.profiles for select
  using (auth.uid() = id);

create policy "Users can update own profile"
  on public.profiles for update
  using (auth.uid() = id);

-- Function to handle new user signup
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer set search_path = public
as $$
begin
  insert into public.profiles (id, email)
  values (new.id, new.email);
  return new;
end;
$$;

-- Trigger to create profile on signup
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

-- Add user_id to social_media_videos table
alter table public.social_media_videos 
  add column user_id uuid references public.profiles(id) on delete cascade;

-- Update social_media_videos RLS policies
create policy "Users can view own videos"
  on public.social_media_videos for select
  using (auth.uid() = user_id);

create policy "Users can insert own videos"
  on public.social_media_videos for insert
  with check (auth.uid() = user_id);

create policy "Users can update own videos"
  on public.social_media_videos for update
  using (auth.uid() = user_id);

create policy "Users can delete own videos"
  on public.social_media_videos for delete
  using (auth.uid() = user_id);