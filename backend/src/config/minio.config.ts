import { registerAs } from '@nestjs/config';

export default registerAs('minio', () => ({
  endPoint: process.env.MINIO_ENDPOINT || 'localhost',
  port: parseInt(process.env.MINIO_PORT, 10) || 9000,
  useSSL: process.env.MINIO_USE_SSL === 'true',
  accessKey: process.env.MINIO_ACCESS_KEY || 'minio_access_key',
  secretKey: process.env.MINIO_SECRET_KEY || 'minio_secret_key',
  publicUrl: process.env.MINIO_PUBLIC_URL || 'http://localhost:9000',
  buckets: {
    avatars: 'avatars',
    posts: 'posts',
    videos: 'videos',
    portfolios: 'portfolios',
  },
}));
