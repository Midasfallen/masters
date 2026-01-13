import { Injectable, LoggerService as NestLoggerService } from '@nestjs/common';
import * as winston from 'winston';
import * as DailyRotateFile from 'winston-daily-rotate-file';

/**
 * Custom Logger Service using Winston
 *
 * Features:
 * - Daily log rotation
 * - Different log levels (error, warn, info, debug)
 * - Structured logging (JSON format)
 * - Separate files for errors and combined logs
 * - Console output with colors (development)
 */
@Injectable()
export class LoggerService implements NestLoggerService {
  private logger: winston.Logger;
  private context?: string;

  constructor(context?: string) {
    this.context = context;
    this.logger = this.createLogger();
  }

  private createLogger(): winston.Logger {
    const isProduction = process.env.NODE_ENV === 'production';

    // Define log format
    const logFormat = winston.format.combine(
      winston.format.timestamp({ format: 'YYYY-MM-DD HH:mm:ss' }),
      winston.format.errors({ stack: true }),
      winston.format.splat(),
      winston.format.json(),
    );

    // Console format for development
    const consoleFormat = winston.format.combine(
      winston.format.colorize(),
      winston.format.timestamp({ format: 'HH:mm:ss' }),
      winston.format.printf(({ timestamp, level, message, context, trace }) => {
        const ctx = context ? `[${context}]` : '';
        return `${timestamp} ${level} ${ctx} ${message}${trace ? `\n${trace}` : ''}`;
      }),
    );

    // Transport: Daily rotate file for errors
    const errorFileTransport = new DailyRotateFile({
      filename: 'logs/error-%DATE%.log',
      datePattern: 'YYYY-MM-DD',
      level: 'error',
      maxSize: '20m',
      maxFiles: '14d',
      format: logFormat,
    });

    // Transport: Daily rotate file for all logs
    const combinedFileTransport = new DailyRotateFile({
      filename: 'logs/combined-%DATE%.log',
      datePattern: 'YYYY-MM-DD',
      maxSize: '20m',
      maxFiles: '14d',
      format: logFormat,
    });

    // Transport: Console
    const consoleTransport = new winston.transports.Console({
      format: isProduction ? logFormat : consoleFormat,
    });

    // Create logger instance
    return winston.createLogger({
      level: isProduction ? 'info' : 'debug',
      format: logFormat,
      defaultMeta: { service: 'service-platform-backend' },
      transports: [errorFileTransport, combinedFileTransport, consoleTransport],
      exceptionHandlers: [
        new DailyRotateFile({
          filename: 'logs/exceptions-%DATE%.log',
          datePattern: 'YYYY-MM-DD',
          maxSize: '20m',
          maxFiles: '14d',
        }),
      ],
      rejectionHandlers: [
        new DailyRotateFile({
          filename: 'logs/rejections-%DATE%.log',
          datePattern: 'YYYY-MM-DD',
          maxSize: '20m',
          maxFiles: '14d',
        }),
      ],
    });
  }

  log(message: string, context?: string) {
    this.logger.info(message, { context: context || this.context });
  }

  error(message: string, trace?: string, context?: string) {
    this.logger.error(message, {
      context: context || this.context,
      trace,
    });
  }

  warn(message: string, context?: string) {
    this.logger.warn(message, { context: context || this.context });
  }

  debug(message: string, context?: string) {
    this.logger.debug(message, { context: context || this.context });
  }

  verbose(message: string, context?: string) {
    this.logger.verbose(message, { context: context || this.context });
  }

  /**
   * Log HTTP request
   */
  logRequest(req: any, res: any, responseTime: number) {
    const { method, originalUrl, ip } = req;
    const { statusCode } = res;
    const userAgent = req.get('user-agent') || '';

    this.logger.info('HTTP Request', {
      context: 'HttpRequest',
      method,
      url: originalUrl,
      statusCode,
      responseTime: `${responseTime}ms`,
      ip,
      userAgent,
    });
  }

  /**
   * Log database query
   */
  logQuery(query: string, parameters: any[], executionTime: number) {
    this.logger.debug('Database Query', {
      context: 'DatabaseQuery',
      query,
      parameters,
      executionTime: `${executionTime}ms`,
    });
  }

  /**
   * Log authentication event
   */
  logAuth(event: 'login' | 'logout' | 'register' | 'refresh', userId: string, ip: string) {
    this.logger.info('Authentication Event', {
      context: 'Authentication',
      event,
      userId,
      ip,
    });
  }

  /**
   * Log security event
   */
  logSecurity(event: string, details: any) {
    this.logger.warn('Security Event', {
      context: 'Security',
      event,
      ...details,
    });
  }

  /**
   * Log performance metric
   */
  logPerformance(operation: string, duration: number, metadata?: any) {
    this.logger.info('Performance Metric', {
      context: 'Performance',
      operation,
      duration: `${duration}ms`,
      ...metadata,
    });
  }

  /**
   * Log business event
   */
  logEvent(event: string, data: any) {
    this.logger.info('Business Event', {
      context: 'BusinessEvent',
      event,
      ...data,
    });
  }
}
