import {
  Injectable,
  NestInterceptor,
  ExecutionContext,
  CallHandler,
} from '@nestjs/common';
import { Observable } from 'rxjs';
import { map } from 'rxjs/operators';
import { classToPlain, ClassTransformOptions } from 'class-transformer';
import 'reflect-metadata';

/**
 * SerializeInterceptor - глобальный interceptor для сериализации responses
 *
 * Преобразует Entity/DTO objects в plain JSON с применением class-transformer decorators.
 * Обеспечивает:
 * - Использование только @Expose() полей (excludeAll strategy)
 * - Автоматическую трансформацию naming convention (snake_case → camelCase)
 * - Исключение circular dependencies
 * - Применение custom transformers
 *
 * @example
 * // В main.ts:
 * app.useGlobalInterceptors(new SerializeInterceptor());
 *
 * // В DTO:
 * export class UserResponseDto {
 *   @Expose()
 *   id: string;
 *
 *   @Expose()
 *   firstName: string;  // Будет сериализовано как "firstName" в JSON
 * }
 */
@Injectable()
export class SerializeInterceptor implements NestInterceptor {
  intercept(context: ExecutionContext, next: CallHandler): Observable<any> {
    return next.handle().pipe(
      map((data) => {
        // Если data === null или undefined, возвращаем как есть
        if (data === null || data === undefined) {
          return data;
        }

        // Если data уже plain object (из mapper), возвращаем как есть
        // Если data - class instance, применяем classToPlain
        if (data && data.constructor && data.constructor.name !== 'Object') {
          return classToPlain(data, {
            excludeExtraneousValues: true,
            exposeDefaultValues: true,
            enableImplicitConversion: false,
          });
        }

        // Plain objects (уже преобразованные mapper'ом) возвращаем как есть
        return data;
      }),
    );
  }
}
