import { ApiProperty } from '@nestjs/swagger';
import { IsString, MinLength, Matches } from 'class-validator';

export class ResetPasswordDto {
  @ApiProperty({
    description: 'Токен сброса пароля из email',
    example: 'abc123xyz789',
  })
  @IsString()
  reset_token: string;

  @ApiProperty({
    description: 'Новый пароль',
    example: 'NewPassword123!',
    minLength: 8,
  })
  @IsString()
  @MinLength(8, { message: 'Пароль должен содержать минимум 8 символов' })
  @Matches(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)/, {
    message:
      'Пароль должен содержать минимум одну заглавную букву, одну строчную букву и одну цифру',
  })
  new_password: string;
}
