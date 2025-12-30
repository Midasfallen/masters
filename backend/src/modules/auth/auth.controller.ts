import { Controller, Post, Body, HttpCode, HttpStatus } from '@nestjs/common';
import {
  ApiTags,
  ApiOperation,
  ApiResponse,
  ApiBearerAuth,
} from '@nestjs/swagger';
import { AuthService } from './auth.service';
import { RegisterDto } from './dto/register.dto';
import { LoginDto } from './dto/login.dto';
import { RefreshTokenDto } from './dto/refresh-token.dto';
import { ForgotPasswordDto } from './dto/forgot-password.dto';
import { ResetPasswordDto } from './dto/reset-password.dto';
import { AuthResponseDto } from './dto/auth-response.dto';
import { Public } from './decorators/public.decorator';

@ApiTags('auth')
@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Public()
  @Post('register')
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({
    summary: 'Регистрация нового пользователя',
    description:
      'В v2.0 все пользователи создаются как клиенты (is_master = false). Для становления мастером нужно пройти 5-шаговое создание профиля.',
  })
  @ApiResponse({
    status: 201,
    description: 'Пользователь успешно зарегистрирован',
    type: AuthResponseDto,
  })
  @ApiResponse({
    status: 409,
    description: 'Пользователь с таким email или телефоном уже существует',
  })
  @ApiResponse({
    status: 400,
    description: 'Некорректные данные',
  })
  async register(@Body() registerDto: RegisterDto): Promise<AuthResponseDto> {
    return this.authService.register(registerDto);
  }

  @Public()
  @Post('login')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Вход в систему',
    description: 'Аутентификация пользователя по email и паролю',
  })
  @ApiResponse({
    status: 200,
    description: 'Успешная аутентификация',
    type: AuthResponseDto,
  })
  @ApiResponse({
    status: 401,
    description: 'Неверный email или пароль',
  })
  async login(@Body() loginDto: LoginDto): Promise<AuthResponseDto> {
    return this.authService.login(loginDto);
  }

  @Public()
  @Post('refresh')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Обновление access token',
    description: 'Получение нового access token по refresh token',
  })
  @ApiResponse({
    status: 200,
    description: 'Токен успешно обновлен',
    type: AuthResponseDto,
  })
  @ApiResponse({
    status: 401,
    description: 'Неверный или истекший refresh token',
  })
  async refresh(
    @Body() refreshTokenDto: RefreshTokenDto,
  ): Promise<AuthResponseDto> {
    return this.authService.refreshToken(refreshTokenDto.refresh_token);
  }

  @Public()
  @Post('forgot-password')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Запрос на сброс пароля',
    description:
      'Отправляет email с токеном для сброса пароля. Всегда возвращает успех (security best practice).',
  })
  @ApiResponse({
    status: 200,
    description: 'Запрос обработан',
    schema: {
      type: 'object',
      properties: {
        message: {
          type: 'string',
          example:
            'Если email существует в системе, на него будет отправлено письмо с инструкциями',
        },
      },
    },
  })
  async forgotPassword(
    @Body() forgotPasswordDto: ForgotPasswordDto,
  ): Promise<{ message: string }> {
    return this.authService.forgotPassword(forgotPasswordDto);
  }

  @Public()
  @Post('reset-password')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Сброс пароля по токену',
    description: 'Устанавливает новый пароль используя токен из email',
  })
  @ApiResponse({
    status: 200,
    description: 'Пароль успешно изменен',
    schema: {
      type: 'object',
      properties: {
        message: {
          type: 'string',
          example:
            'Пароль успешно изменен. Теперь вы можете войти с новым паролем',
        },
      },
    },
  })
  @ApiResponse({
    status: 400,
    description: 'Неверный или истекший токен',
  })
  async resetPassword(
    @Body() resetPasswordDto: ResetPasswordDto,
  ): Promise<{ message: string }> {
    return this.authService.resetPassword(resetPasswordDto);
  }
}
