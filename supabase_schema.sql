-- Create a table for skills
create table public.skills (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references auth.users(id) on delete cascade not null,
  name text not null,
  confidence integer not null check (confidence >= 0 and confidence <= 100),
  source text not null, -- e.g., 'GitHub', 'Resume', 'Manual'
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- Enable Row Level Security
alter table public.skills enable row level security;

-- Create policies
create policy "Users can view their own skills."
  on public.skills for select
  using ( auth.uid() = user_id );

create policy "Users can insert their own skills."
  on public.skills for insert
  with check ( auth.uid() = user_id );

create policy "Users can update their own skills."
  on public.skills for update
  using ( auth.uid() = user_id );

create policy "Users can delete their own skills."
  on public.skills for delete
  using ( auth.uid() = user_id );
