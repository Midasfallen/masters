import { Injectable, NestMiddleware } from '@nestjs/common';
import { Request, Response, NextFunction } from 'express';
import { LoggerService } from '../services/logger.service';

/**
 * HTTP Logger Middleware
 *
 * Logs all incoming HTTP requests with:
 * - Method, URL, Status Code
 * - Response time
 * - User IP, User Agent
 * - Request/Response size
 */
@Injectable()
export class HttpLoggerMiddleware implements NestMiddleware {
  private logger = new LoggerService('HttpLogger');

  use(req: Request, res: Response, next: NextFunction) {
    const startTime = Date.now();
    const { method, originalUrl, ip } = req;

    // Log request
    this.logger.debug(`→ ${method} ${originalUrl}`, 'HttpRequest');

    // Log response when finished
    res.on('finish', () => {
      const { statusCode } = res;
      const responseTime = Date.now() - startTime;
      const contentLength = res.get('content-length') || '0';

      // Determine log level based on status code
      if (statusCode >= 500) {
        this.logger.error(
          `← ${method} ${originalUrl} ${statusCode} ${responseTime}ms`,
          undefined,
          'HttpResponse',
        );
      } else if (statusCode >= 400) {
        this.logger.warn(
          `← ${method} ${originalUrl} ${statusCode} ${responseTime}ms`,
          'HttpResponse',
        );
      } else {
        this.logger.log(
          `← ${method} ${originalUrl} ${statusCode} ${responseTime}ms`,
          'HttpResponse',
        );
      }

      // Log detailed metrics
      this.logger.logRequest(req, res, responseTime);

      // Log slow requests (>1s)
      if (responseTime > 1000) {
        this.logger.logPerformance('SlowRequest', responseTime, {
          method,
          url: originalUrl,
          statusCode,
          ip,
        });
      }
    });

    next();
  }
}
