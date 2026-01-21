import { Injectable, Logger, BadRequestException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import * as AWS from 'aws-sdk';
import { v4 as uuidv4 } from 'uuid';
import * as path from 'path';

@Injectable()
export class UploadService {
  private readonly logger = new Logger(UploadService.name);
  private readonly s3: AWS.S3;
  private readonly buckets: Record<string, string>;

  constructor(private configService: ConfigService) {
    // Configure AWS SDK for MinIO
    const endpoint = this.configService.get<string>('minio.endPoint');
    const port = this.configService.get<number>('minio.port');
    const useSSL = this.configService.get<boolean>('minio.useSSL');
    const accessKey = this.configService.get<string>('minio.accessKey');
    const secretKey = this.configService.get<string>('minio.secretKey');

    this.buckets = this.configService.get<Record<string, string>>('minio.buckets');

    this.s3 = new AWS.S3({
      endpoint: `${useSSL ? 'https' : 'http'}://${endpoint}:${port}`,
      accessKeyId: accessKey,
      secretAccessKey: secretKey,
      s3ForcePathStyle: true, // Required for MinIO
      signatureVersion: 'v4',
    });

    this.logger.log(`MinIO configured: ${endpoint}:${port}`);
  }

  /**
   * Upload avatar image
   */
  async uploadAvatar(file: Express.Multer.File, userId: string): Promise<string> {
    const bucket = this.buckets.avatars;
    return this.uploadFile(file, bucket, `avatar-${userId}`);
  }

  /**
   * Upload post media (photo/video)
   */
  async uploadPostMedia(file: Express.Multer.File, postId: string): Promise<string> {
    const bucket = this.buckets.posts;
    return this.uploadFile(file, bucket, `post-${postId}`);
  }

  /**
   * Upload portfolio image
   */
  async uploadPortfolio(file: Express.Multer.File, masterId: string): Promise<string> {
    const bucket = this.buckets.portfolios;
    return this.uploadFile(file, bucket, `portfolio-${masterId}`);
  }

  /**
   * Upload video
   */
  async uploadVideo(file: Express.Multer.File, userId: string): Promise<string> {
    const bucket = this.buckets.videos;
    return this.uploadFile(file, bucket, `video-${userId}`);
  }

  /**
   * Generic file upload to MinIO
   */
  private async uploadFile(
    file: Express.Multer.File,
    bucket: string,
    prefix: string,
  ): Promise<string> {
    // Validate file
    if (!file) {
      throw new BadRequestException('No file provided');
    }

    // Generate unique filename
    const fileExt = path.extname(file.originalname);
    const fileName = `${prefix}-${uuidv4()}${fileExt}`;

    try {
      // Upload to MinIO
      const uploadResult = await this.s3
        .upload({
          Bucket: bucket,
          Key: fileName,
          Body: file.buffer,
          ContentType: file.mimetype,
          ACL: 'public-read', // Make files publicly accessible
        })
        .promise();

      this.logger.log(`File uploaded: ${uploadResult.Location}`);
      return uploadResult.Location;
    } catch (error) {
      this.logger.error(`Upload failed: ${error.message}`, error.stack);
      throw new BadRequestException(`Failed to upload file: ${error.message}`);
    }
  }

  /**
   * Delete file from MinIO
   */
  async deleteFile(fileUrl: string): Promise<void> {
    try {
      // Extract bucket and key from URL
      const url = new URL(fileUrl);
      const pathParts = url.pathname.split('/').filter(Boolean);

      if (pathParts.length < 2) {
        throw new Error('Invalid file URL');
      }

      const bucket = pathParts[0];
      const key = pathParts.slice(1).join('/');

      await this.s3
        .deleteObject({
          Bucket: bucket,
          Key: key,
        })
        .promise();

      this.logger.log(`File deleted: ${fileUrl}`);
    } catch (error) {
      this.logger.error(`Delete failed: ${error.message}`, error.stack);
      throw new BadRequestException(`Failed to delete file: ${error.message}`);
    }
  }

  /**
   * Get file info
   */
  async getFileInfo(fileUrl: string): Promise<AWS.S3.HeadObjectOutput> {
    try {
      const url = new URL(fileUrl);
      const pathParts = url.pathname.split('/').filter(Boolean);

      const bucket = pathParts[0];
      const key = pathParts.slice(1).join('/');

      return await this.s3
        .headObject({
          Bucket: bucket,
          Key: key,
        })
        .promise();
    } catch (error) {
      this.logger.error(`Get file info failed: ${error.message}`, error.stack);
      throw new BadRequestException(`Failed to get file info: ${error.message}`);
    }
  }

  /**
   * Check if bucket exists and is accessible
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
