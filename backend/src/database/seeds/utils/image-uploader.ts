import * as https from 'https';
import * as http from 'http';
import * as AWS from 'aws-sdk';
import { v4 as uuidv4 } from 'uuid';

export interface ImageUploaderConfig {
  endpoint: string;
  port: number;
  accessKey: string;
  secretKey: string;
  useSSL: boolean;
}

export class ImageUploader {
  private readonly s3: AWS.S3;

  constructor(config: ImageUploaderConfig) {
    this.s3 = new AWS.S3({
      endpoint: `${config.useSSL ? 'https' : 'http'}://${config.endpoint}:${config.port}`,
      accessKeyId: config.accessKey,
      secretAccessKey: config.secretKey,
      s3ForcePathStyle: true,
      signatureVersion: 'v4',
    });
  }

  /**
   * Download image from URL and upload to MinIO
   */
  async uploadFromUrl(
    imageUrl: string,
    bucket: string,
    prefix: string,
  ): Promise<string> {
    try {
      // Download image
      const imageBuffer = await this.downloadImage(imageUrl);

      // Generate filename
      const fileName = `${prefix}-${uuidv4()}.jpg`;

      // Upload to MinIO
      const uploadResult = await this.s3
        .upload({
          Bucket: bucket,
          Key: fileName,
          Body: imageBuffer,
          ContentType: 'image/jpeg',
          ACL: 'public-read',
        })
        .promise();

      console.log(`[UPLOAD] ${imageUrl} -> ${uploadResult.Location}`);
      return uploadResult.Location;
    } catch (error) {
      console.error(`[ERROR] Failed to upload ${imageUrl}:`, error.message);
      // Fallback to original URL if upload fails
      return imageUrl;
    }
  }

  /**
   * Download image from URL
   */
  private downloadImage(url: string): Promise<Buffer> {
    return new Promise((resolve, reject) => {
      const protocol = url.startsWith('https') ? https : http;

      protocol
        .get(url, (response) => {
          if (response.statusCode !== 200) {
            reject(new Error(`Failed to download: ${response.statusCode}`));
            return;
          }

          const chunks: Buffer[] = [];

          response.on('data', (chunk) => {
            chunks.push(chunk);
          });

          response.on('end', () => {
            resolve(Buffer.concat(chunks));
          });
        })
        .on('error', (error) => {
          reject(error);
        });
    });
  }

  /**
   * Check if bucket exists
   */
  async checkBucket(bucketName: string): Promise<boolean> {
    try {
      await this.s3.headBucket({ Bucket: bucketName }).promise();
      return true;
    } catch (error) {
      return false;
    }
  }
}
