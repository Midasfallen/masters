import { Module, Global } from '@nestjs/common';
import { WinstonModule } from 'nest-winston';
import { winstonConfig } from './winston.config';

/**
 * Logger Module - Global Winston Logger
 *
 * This module provides a global Winston logger that can be used
 * throughout the application for structured logging.
 *
 * Usage in services:
 *
 * import { Inject, Injectable } from '@nestjs/common';
 * import { WINSTON_MODULE_PROVIDER } from 'nest-winston';
 * import { Logger } from 'winston';
 *
 * @Injectable()
 * export class MyService {
 *   constructor(
 *     @Inject(WINSTON_MODULE_PROVIDER) private readonly logger: Logger
 *   ) {}
 *
 *   someMethod() {
 *     this.logger.info('This is an info message', { context: 'MyService' });
 *     this.logger.error('This is an error', { context: 'MyService', error: err });
 *   }
 * }
 */

@Global()
@Module({
  imports: [
    WinstonModule.forRoot(winstonConfig),
  ],
  exports: [WinstonModule],
})
export class LoggerModule {}
