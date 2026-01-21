import { registerAs } from '@nestjs/config';

export default registerAs('smtp', () => ({
  host: process.env.SMTP_HOST || 'localhost',
  port: parseInt(process.env.SMTP_PORT, 10) || 1025,
  secure: process.env.SMTP_SECURE === 'true',
  from: {
    email: process.env.SMTP_FROM_EMAIL || 'noreply@serviceplatform.com',
    name: process.env.SMTP_FROM_NAME || 'Service Platform',
  },
}));
