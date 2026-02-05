/**
 * Загружает тестовые изображения из test-images/posts и test-images/avatars в MinIO.
 * - posts: до 24 файлов → бакет posts, имена test-1.jpg … test-24.jpg
 * - avatars: до 11 файлов → бакет avatars, имена avatar-1.jpg … avatar-11.jpg
 *
 * Сид уже пишет в БД ссылки на эти URL. Запуск после размещения файлов:
 *   npm run upload-test-images
 */
import * as fs from 'fs';
import * as path from 'path';
import * as AWS from 'aws-sdk';

const POSTS_BUCKET = 'posts';
const AVATARS_BUCKET = 'avatars';
const MAX_POSTS = 24;
const MAX_AVATARS = 11;
const BASE_DIR = path.join(__dirname, 'test-images');

function getEndpoint(): string {
  const host = process.env.MINIO_ENDPOINT || 'localhost';
  const port = process.env.MINIO_PORT || '9000';
  const ssl = process.env.MINIO_USE_SSL === 'true';
  return `${ssl ? 'https' : 'http'}://${host}:${port}`;
}

function getS3(): AWS.S3 {
  return new AWS.S3({
    endpoint: getEndpoint(),
    accessKeyId: process.env.MINIO_ACCESS_KEY || 'minio_access_key',
    secretAccessKey: process.env.MINIO_SECRET_KEY || 'minio_secret_key',
    s3ForcePathStyle: true,
    signatureVersion: 'v4',
  });
}

async function uploadFromDir(
  s3: AWS.S3,
  dir: string,
  bucket: string,
  keyPrefix: string,
  maxFiles: number,
  label: string,
): Promise<number> {
  if (!fs.existsSync(dir)) {
    console.warn(`⚠️ Папка не найдена: ${dir}`);
    return 0;
  }

  const files = fs.readdirSync(dir)
    .filter((f) => /\.(jpe?g|png)$/i.test(f))
    .slice(0, maxFiles);

  if (files.length === 0) {
    console.warn(`⚠️ Нет изображений (JPG/PNG) в ${dir}`);
    return 0;
  }

  console.log(`\n📁 ${label}: ${path.resolve(dir)}`);
  for (let i = 0; i < files.length; i++) {
    const n = i + 1;
    const key = `${keyPrefix}-${n}.jpg`;
    const filePath = path.join(dir, files[i]);
    const body = fs.readFileSync(filePath);
    const ext = path.extname(files[i]).toLowerCase();
    const contentType = /\.png$/i.test(ext) ? 'image/png' : 'image/jpeg';

    await s3.upload({
      Bucket: bucket,
      Key: key,
      Body: body,
      ContentType: contentType,
      ACL: 'public-read',
    }).promise();

    console.log(`  📤 ${files[i]} → ${bucket}/${key}`);
  }
  return files.length;
}

async function uploadTestImages() {
  console.log('🚀 Загрузка тестовых изображений в MinIO\n');
  console.log(`📂 Базовая папка: ${path.resolve(BASE_DIR)}`);

  if (!fs.existsSync(BASE_DIR)) {
    console.warn(`\n⚠️ Папка не найдена: ${BASE_DIR}`);
    console.log(`
Создайте структуру:
  ${path.resolve(BASE_DIR)}/
    posts/   — до 24 изображений (test-1.jpg … test-24.jpg в бакете posts)
    avatars/ — до 11 изображений (avatar-1.jpg … avatar-11.jpg в бакете avatars)

Затем запустите: npm run upload-test-images
`);
    process.exit(1);
  }

  const s3 = getS3();
  const postsDir = path.join(BASE_DIR, 'posts');
  const avatarsDir = path.join(BASE_DIR, 'avatars');

  const postsCount = await uploadFromDir(
    s3,
    postsDir,
    POSTS_BUCKET,
    'test',
    MAX_POSTS,
    'Посты (posts/)',
  );
  const avatarsCount = await uploadFromDir(
    s3,
    avatarsDir,
    AVATARS_BUCKET,
    'avatar',
    MAX_AVATARS,
    'Аватары (avatars/)',
  );

  if (postsCount === 0 && avatarsCount === 0) {
    console.warn('\n⚠️ Ни один файл не загружен. Положите JPG/PNG в posts/ и/или avatars/.');
    process.exit(1);
  }

  const baseUrl = process.env.MINIO_PUBLIC_URL || 'http://localhost:9000';
  console.log('\n✨ Готово.');
  if (postsCount > 0) {
    console.log(`   Посты: ${baseUrl}/posts/test-1.jpg … test-${postsCount}.jpg`);
  }
  if (avatarsCount > 0) {
    console.log(`   Аватары: ${baseUrl}/avatars/avatar-1.jpg … avatar-${avatarsCount}.jpg`);
  }
}

uploadTestImages()
  .then(() => process.exit(0))
  .catch((err) => {
    console.error('❌ Ошибка:', err.message);
    process.exit(1);
  });
