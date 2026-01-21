import { NestFactory } from '@nestjs/core';
import { AppModule } from '../../app.module';
import { DataSource } from 'typeorm';
import * as fs from 'fs';
import * as path from 'path';
import * as AWS from 'aws-sdk';
import { v4 as uuidv4 } from 'uuid';
import { PostMedia } from '../../modules/posts/entities/post-media.entity';

const LOCAL_IMAGES_DIR = 'C:\\Users\\ravin\\Downloads\\Красивые бесплатные изображения и картинки _ Unsplash';

async function uploadLocalImages() {
  console.log('[UPLOAD] Starting local images upload to MinIO...\n');

  const app = await NestFactory.createApplicationContext(AppModule);
  const dataSource = app.get(DataSource);

  try {
    // Initialize MinIO S3 client
    const s3 = new AWS.S3({
      endpoint: `http://localhost:9000`,
      accessKeyId: process.env.MINIO_ACCESS_KEY || 'minio_access_key',
      secretAccessKey: process.env.MINIO_SECRET_KEY || 'minio_secret_key',
      s3ForcePathStyle: true,
      signatureVersion: 'v4',
    });

    // Read local images
    console.log('[UPLOAD] Reading local images from:', LOCAL_IMAGES_DIR);
    const files = fs.readdirSync(LOCAL_IMAGES_DIR)
      .filter(file => file.toLowerCase().endsWith('.jpg') || file.toLowerCase().endsWith('.jpeg'))
      .slice(0, 14); // Take first 14 images for 14 posts

    console.log('[UPLOAD] Found images:', files.length);

    if (files.length === 0) {
      throw new Error('No JPEG images found in directory');
    }

    if (files.length < 14) {
      console.log(`[WARN] Found only ${files.length} images, but need 14. Will use available images.`);
    }

    // Upload images to MinIO
    const uploadedUrls: string[] = [];

    for (const file of files) {
      const filePath = path.join(LOCAL_IMAGES_DIR, file);
      const fileBuffer = fs.readFileSync(filePath);

      const fileName = `post-${uuidv4()}.jpg`;

      console.log(`[UPLOAD] Uploading ${file} -> ${fileName}...`);

      const uploadResult = await s3.upload({
        Bucket: 'posts',
        Key: fileName,
        Body: fileBuffer,
        ContentType: 'image/jpeg',
        ACL: 'public-read',
      }).promise();

      uploadedUrls.push(uploadResult.Location);
      console.log(`[UPLOAD] Success: ${uploadResult.Location}`);
    }

    // Update database
    console.log('\n[DATABASE] Updating post_media records...');

    const postMediaRepository = dataSource.getRepository(PostMedia);
    const allPostMedia = await postMediaRepository.find({
      order: { id: 'ASC' }
    });

    console.log('[DATABASE] Found post_media records:', allPostMedia.length);

    for (let i = 0; i < allPostMedia.length && i < uploadedUrls.length; i++) {
      const postMedia = allPostMedia[i];
      const newUrl = uploadedUrls[i];

      console.log(`[DATABASE] Updating post_media #${postMedia.id}:`);
      console.log(`  Old: ${postMedia.url}`);
      console.log(`  New: ${newUrl}`);

      postMedia.url = newUrl;
      postMedia.thumbnail_url = newUrl; // Use same URL for thumbnail

      await postMediaRepository.save(postMedia);
    }

    console.log('\n[SUCCESS] All images uploaded and database updated!');
    console.log('[SUMMARY]');
    console.log('  - Images uploaded:', uploadedUrls.length);
    console.log('  - Database records updated:', Math.min(allPostMedia.length, uploadedUrls.length));

  } catch (error) {
    console.error('[ERROR] Upload failed:', error);
    throw error;
  } finally {
    await app.close();
  }
}

uploadLocalImages()
  .then(() => {
    console.log('\n✨ Upload process completed successfully!');
    process.exit(0);
  })
  .catch((error) => {
    console.error('❌ Upload process failed:', error);
    process.exit(1);
  });
