import * as winston from 'winston';
import * as DailyRotateFile from 'winston-daily-rotate-file';
import { utilities as nestWinstonModuleUtilities } from 'nest-winston';

/**
 * Winston Logger Configuration
 *
 * Provides structured logging with:
 * - Console output (development)
 * - Daily rotating files (production)
 * - Error-specific log files
 * - JSON format for production
 * - Pretty format for development
 */

const isDevelopment = process.env.NODE_ENV !== 'production';

// Define log levels
const logLevels = {
  error: 0,
  warn: 1,
  info: 2,
  http: 3,
  debug: 4,
};

// Custom format for better readability
const customFormat = winston.format.combine(
  winston.format.timestamp({ format: 'YYYY-MM-DD HH:mm:ss' }),
  winston.format.errors({ stack: true }),
  winston.format.splat(),
  winston.format.json(),
);

// Pretty format for development
const devFormat = winston.format.combine(
  winston.format.timestamp({ format: 'YYYY-MM-DD HH:mm:ss' }),
  winston.format.ms(),
  nestWinstonModuleUtilities.format.nestLike('ServicePlatform', {
    colors: true,
    prettyPrint: true,
  }),
);

// Configure transports
const transports: winston.transport[] = [];

// Console transport (always enabled in development, optional in production)
if (isDevelopment || process.env.LOG_CONSOLE === 'true') {
  transports.push(
    new winston.transports.Console({
      format: isDevelopment ? devFormat : customFormat,
      level: process.env.LOG_LEVEL || (isDevelopment ? 'debug' : 'info'),
    }),
  );
}

// File transports (production)
if (!isDevelopment) {
  // All logs
  transports.push(
    new DailyRotateFile({
      filename: 'logs/application-%DATE%.log',
      datePattern: 'YYYY-MM-DD',
      zippedArchive: true,
      maxSize: '20m',
      maxFiles: '14d',
      format: customFormat,
      level: 'info',
    }),
  );

  // Error logs
  transports.push(
    new DailyRotateFile({
      filename: 'logs/error-%DATE%.log',
      datePattern: 'YYYY-MM-DD',
      zippedArchive: true,
      maxSize: '20m',
      maxFiles: '30d',
      format: customFormat,
      level: 'error',
    }),
  );

  // HTTP logs (for request tracking)
  transports.push(
    new DailyRotateFile({
      filename: 'logs/http-%DATE%.log',
      datePattern: 'YYYY-MM-DD',
      zippedArchive: true,
      maxSize: '20m',
      maxFiles: '7d',
      format: customFormat,
      level: 'http',
    }),
  );
}

// Winston instance configuration
export const winstonConfig = {
  levels: logLevels,
  format: customFormat,
  transports,
  exitOnError: false,
  // Exception handling
  exceptionHandlers: [
    new winston.transports.File({ filename: 'logs/exceptions.log' }),
  ],
  // Rejection handling
  rejectionHandlers: [
    new winston.transports.File({ filename: 'logs/rejections.log' }),
  ],
};

// Create and export the winston logger instance
export const createWinstonLogger = () => {
  return winston.createLogger(winstonConfig);
};
