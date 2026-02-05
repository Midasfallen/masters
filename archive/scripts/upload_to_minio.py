#!/usr/bin/env python3
"""Upload images to MinIO"""
import os
from minio import Minio
from minio.error import S3Error
import sys

# MinIO configuration
client = Minio(
    "localhost:9000",
    access_key="minio_access_key",
    secret_key="minio_secret_key",
    secure=False
)

bucket_name = "avatars"

# Images to upload from local folder
images_folder = r"C:\masters\masters\images"
files_to_upload = {
    "img1.jpg": "anna-avatar.jpg",
    "img2.jpg": "dmitry-avatar.jpg", 
    "img3.jpg": "elena-avatar.jpg",
}

try:
    # Upload each image
    for local_file, remote_name in files_to_upload.items():
        local_path = os.path.join(images_folder, local_file)
        if os.path.exists(local_path):
            file_size = os.path.getsize(local_path)
            with open(local_path, "rb") as f:
                client.put_object(
                    bucket_name,
                    remote_name,
                    f,
                    file_size,
                    content_type="image/jpeg"
                )
            print(f"✓ Uploaded {remote_name}")
        else:
            print(f"✗ File not found: {local_path}")
            
    print("\n✓ All images uploaded successfully!")
    
except S3Error as e:
    print(f"Error: {e}", file=sys.stderr)
    sys.exit(1)
