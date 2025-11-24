-- Create storage bucket for ad assets
INSERT INTO storage.buckets (id, name, public)
VALUES ('ad-assets', 'ad-assets', true)
ON CONFLICT (id) DO NOTHING;

-- Enable public access to the bucket
CREATE POLICY "Public Access"
ON storage.objects FOR SELECT
USING (bucket_id = 'ad-assets');

-- Allow authenticated users to upload
CREATE POLICY "Authenticated users can upload"
ON storage.objects FOR INSERT
WITH CHECK (bucket_id = 'ad-assets');

-- Allow authenticated users to delete their own uploads
CREATE POLICY "Authenticated users can delete"
ON storage.objects FOR DELETE
USING (bucket_id = 'ad-assets');
