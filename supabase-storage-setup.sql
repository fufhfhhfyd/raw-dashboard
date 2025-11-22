-- Create Storage Bucket for Ad Files
-- IMPORTANT: Run this SQL in your Supabase SQL Editor before uploading images
-- Dashboard → SQL Editor → New Query → Paste and Run

-- Create the bucket (public so images are accessible via URL)
insert into storage.buckets (id, name, public)
values ('ad-files', 'ad-files', true)
on conflict (id) do nothing;

-- Allow anyone to read files (public bucket)
create policy "Public read access for ad-files"
on storage.objects for select
using ( bucket_id = 'ad-files' );

-- Allow anyone to upload files (anon users)
create policy "Anyone can upload to ad-files"
on storage.objects for insert
with check ( bucket_id = 'ad-files' );

-- Allow anyone to update files
create policy "Anyone can update ad-files"
on storage.objects for update
using ( bucket_id = 'ad-files' );

-- Allow anyone to delete files
create policy "Anyone can delete ad-files"
on storage.objects for delete
using ( bucket_id = 'ad-files' );
