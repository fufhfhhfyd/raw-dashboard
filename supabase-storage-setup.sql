-- Create Storage Bucket for Ad Files
-- Run this SQL in your Supabase SQL Editor

-- Create the bucket
insert into storage.buckets (id, name, public)
values ('ad-files', 'ad-files', true)
on conflict (id) do nothing;

-- Set up RLS policies for the bucket
-- Allow public read access
create policy "Public Access for ad-files"
on storage.objects for select
using ( bucket_id = 'ad-files' );

-- Allow authenticated users to upload
create policy "Authenticated users can upload ad-files"
on storage.objects for insert
with check ( bucket_id = 'ad-files' );

-- Allow authenticated users to update their files
create policy "Authenticated users can update ad-files"
on storage.objects for update
using ( bucket_id = 'ad-files' );

-- Allow authenticated users to delete their files
create policy "Authenticated users can delete ad-files"
on storage.objects for delete
using ( bucket_id = 'ad-files' );
