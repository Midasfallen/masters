import { NestFactory } from '@nestjs/core';
import { AppModule } from '../../app.module';
import { DataSource } from 'typeorm';
import * as fs from 'fs';
import * as path from 'path';
import * as AWS from 'aws-sdk';
import { v4 as uuidv4 } from 'uuid';
import { PostMedia } from '../../modules/posts/entities/post-media.entity';

// Путь к твоим изображениям
const LOCAL_IMAGES_DIR = 'C:\\Users\\ravin\\Downloads\\Красивые бесплатные изображения и картинки _ Unsplash';

async function uploadLocalImages() {
  console.log('🚀 [START] Начинаем загрузку локальных изображений в MinIO...\n');

  const app = await NestFactory.createApplicationContext(AppModule);
  const dataSource = app.get(DataSource);

  try {
    // Настройка клиента S3 (MinIO)
    const s3 = new AWS.S3({
      endpoint: `http://localhost:9000`,
      accessKeyId: process.env.MINIO_ACCESS_KEY || 'minio_access_key',
      secretAccessKey: process.env.MINIO_SECRET_KEY || 'minio_secret_key',
      s3ForcePathStyle: true,
      signatureVersion: 'v4',
    });

    // Читаем файлы, поддерживаем JPG, JPEG и PNG в любом регистре
    console.log(`📁 [FILES] Читаем папку: ${LOCAL_IMAGES_DIR}`);
    if (!fs.existsSync(LOCAL_IMAGES_DIR)) {
        throw new Error(`Папка не найдена по пути: ${LOCAL_IMAGES_DIR}`);
    }

    const files = fs.readdirSync(LOCAL_IMAGES_DIR)
      .filter(file => /\.(jpe?g|png)$/i.test(file))
      .slice(0, 14);

    console.log(`✅ [FILES] Найдено подходящих изображений: ${files.length}`);

    if (files.length === 0) {
      throw new Error('В указанной папке не найдено изображений формата JPG или PNG!');
    }

    const uploadedUrls: string[] = [];

    // Цикл загрузки файлов в MinIO
    for (const file of files) {
      const filePath = path.join(LOCAL_IMAGES_DIR, file);
      const fileBuffer = fs.readFileSync(filePath);
      const fileName = `post-${uuidv4()}.jpg`;

      console.log(`📤 [UPLOAD] Загружаем: ${file} -> ${fileName}...`);

      const uploadResult = await s3.upload({
        Bucket: 'posts',
        Key: fileName,
        Body: fileBuffer,
        ContentType: 'image/jpeg',
        ACL: 'public-read',
      }).promise();

      uploadedUrls.push(uploadResult.Location);
    }

    // Обновление базы данных
    console.log('\n🗄️ [DATABASE] Обновляем записи в таблице post_media...');

    const postMediaRepository = dataSource.getRepository(PostMedia);
    const allPostMedia = await postMediaRepository.find({
      order: { id: 'ASC' }
    });

    if (allPostMedia.length === 0) {
        console.warn('⚠️ [WARN] В базе данных нет записей post_media. Сначала запустите основной сид!');
    } else {
        for (let i = 0; i < allPostMedia.length && i < uploadedUrls.length; i++) {
            const postMedia = allPostMedia[i];
            const newUrl = uploadedUrls[i];

            postMedia.url = newUrl;
            postMedia.thumbnail_url = newUrl;

            await postMediaRepository.save(postMedia);
            console.log(`✅ [DB] Запись #${postMedia.id} обновлена новым URL`);
        }
    }

    console.log('\n✨ [SUCCESS] Все изображения загружены, база данных синхронизирована!');

  } catch (error) {
    console.error('\n❌ [ERROR] Произошла ошибка:', error.message);
  } finally {
    await app.close();
  }
}

// Запуск функции
uploadLocalImages()
  .then(() => {
    console.log('🏁 Скрипт завершен.');
    process.exit(0);
  })
  .catch((err) => {
    console.error('💥 Критическая ошибка при выполнении:', err);
    process.exit(1);
  });