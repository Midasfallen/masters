#!/bin/sh

# Wait for MinIO to be ready
sleep 5

# Configure mc (MinIO Client)
mc alias set myminio http://minio:9000 minio_access_key minio_secret_key

# Create buckets
mc mb myminio/avatars --ignore-existing
mc mb myminio/posts --ignore-existing
mc mb myminio/videos --ignore-existing
mc mb myminio/portfolios --ignore-existing

# Set public policy for buckets (allow downloads)
mc policy set download myminio/avatars
mc policy set download myminio/posts
mc policy set download myminio/videos
mc policy set download myminio/portfolios

echo "MinIO buckets initialized successfully"
