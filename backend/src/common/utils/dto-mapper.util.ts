import { plainToClass, ClassConstructor } from 'class-transformer';

/**
 * Utility для преобразования plain objects в DTO instances с применением class-transformer decorators
 */
export class DtoMapper {
  /**
   * Преобразует plain object или массив objects в DTO instance(s)
   * Применяет все @Expose(), @Transform() и другие decorators
   *
   * @param cls - DTO class constructor
   * @param plain - Plain object или массив objects
   * @returns DTO instance или массив DTO instances
   *
   * @example
   * const userDto = DtoMapper.toDto(UserResponseDto, user);
   * const usersDto = DtoMapper.toDto(UserResponseDto, users);
   */
  static toDto<T, V>(cls: ClassConstructor<T>, plain: V | V[]): T | T[] {
    return plainToClass(cls, plain, {
      strategy: 'excludeAll', // Только поля с @Expose()
      excludeExtraneousValues: true,
      enableImplicitConversion: false,
      exposeDefaultValues: false,
    });
  }
}
