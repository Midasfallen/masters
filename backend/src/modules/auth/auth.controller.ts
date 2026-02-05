import { Controller, Post, Body, HttpCode, HttpStatus } from '@nestjs/common';
import {
  ApiTags,
  ApiOperation,
  ApiResponse,
  ApiBearerAuth,
  ApiCreatedResponse,
  ApiOkResponse,
  ApiBadRequestResponse,
  ApiUnauthorizedResponse,
  ApiConflictResponse,
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
  @ApiCreatedResponse({
    description: 'Пользователь успешно зарегистрирован',
    type: AuthResponseDto,
    schema: {
      example: {
        accessToken: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI1NTBlODQwMC1lMjliLTQxZDQtYTcxNi00NDY2NTU0NDAwMDAiLCJlbWFpbCI6InVzZXJAZXhhbXBsZS5jb20iLCJpYXQiOjE3MDY3ODk2MDAsImV4cCI6MTcwNzM5NDQwMH0.example',
        refreshToken: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI1NTBlODQwMC1lMjliLTQxZDQtYTcxNi00NDY2NTU0NDAwMDAiLCJ0eXBlIjoicmVmcmVzaCIsImlhdCI6MTcwNjc4OTYwMCwiZXhwIjoxNzA5MzgxNjAwfQ.example',
        tokenType: 'Bearer',
        expiresIn: 604800,
        user: {
          id: '550e8400-e29b-41d4-a716-446655440000',
          email: 'user@example.com',
          firstName: 'Иван',
          lastName: 'Петров',
          avatarUrl: null,
          isMaster: false,
          isVerified: false,
          isPremium: false,
        },
      },
    },
  })
  @ApiBadRequestResponse({
    description: 'Некорректные данные',
    schema: {
      example: {
        statusCode: 400,
        message: [
          'email must be an email',
          'password must be longer than or equal to 8 characters',
          'password must contain letters and numbers',
          'first_name must be longer than or equal to 2 characters',
        ],
        error: 'Bad Request',
      },
    },
  })
  @ApiConflictResponse({
    description: 'Пользователь с таким email или телефоном уже существует',
    schema: {
      example: {
        statusCode: 409,
        message: 'User with this email or phone already exists',
        error: 'Conflict',
      },
    },
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
  @ApiOkResponse({
    description: 'Успешная аутентификация',
    type: AuthResponseDto,
    schema: {
      example: {
        accessToken: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI1NTBlODQwMC1lMjliLTQxZDQtYTcxNi00NDY2NTU0NDAwMDAiLCJlbWFpbCI6InVzZXJAZXhhbXBsZS5jb20iLCJpYXQiOjE3MDY3ODk2MDAsImV4cCI6MTcwNzM5NDQwMH0.example',
        refreshToken: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI1NTBlODQwMC1lMjliLTQxZDQtYTcxNi00NDY2NTU0NDAwMDAiLCJ0eXBlIjoicmVmcmVzaCIsImlhdCI6MTcwNjc4OTYwMCwiZXhwIjoxNzA5MzgxNjAwfQ.example',
        tokenType: 'Bearer',
        expiresIn: 604800,
        user: {
          id: '550e8400-e29b-41d4-a716-446655440000',
          email: 'user@example.com',
          firstName: 'Иван',
          lastName: 'Петров',
          avatarUrl: 'https://example.com/avatar.jpg',
          isMaster: true,
          isVerified: true,
          isPremium: false,
        },
      },
    },
  })
  @ApiBadRequestResponse({
    description: 'Некорректные данные',
    schema: {
      example: {
        statusCode: 400,
        message: ['email must be an email', 'password should not be empty'],
        error: 'Bad Request',
      },
    },
  })
  @ApiUnauthorizedResponse({
    description: 'Неверный email или пароль',
    schema: {
      example: {
        statusCode: 401,
        message: 'Invalid email or password',
        error: 'Unauthorized',
      },
    },
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
  @ApiOkResponse({
    description: 'Токен успешно обновлен',
    type: AuthResponseDto,
    schema: {
      example: {
        accessToken: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI1NTBlODQwMC1lMjliLTQxZDQtYTcxNi00NDY2NTU0NDAwMDAiLCJlbWFpbCI6InVzZXJAZXhhbXBsZS5jb20iLCJpYXQiOjE3MDY3ODk2MDAsImV4cCI6MTcwNzM5NDQwMH0.new',
        refreshToken: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI1NTBlODQwMC1lMjliLTQxZDQtYTcxNi00NDY2NTU0NDAwMDAiLCJ0eXBlIjoicmVmcmVzaCIsImlhdCI6MTcwNjc4OTYwMCwiZXhwIjoxNzA5MzgxNjAwfQ.new',
        tokenType: 'Bearer',
        expiresIn: 604800,
        user: {
          id: '550e8400-e29b-41d4-a716-446655440000',
          email: 'user@example.com',
          firstName: 'Иван',
          lastName: 'Петров',
          avatarUrl: null,
          isMaster: false,
          isVerified: false,
          isPremium: false,
        },
      },
    },
  })
  @ApiBadRequestResponse({
    description: 'Некорректные данные',
    schema: {
      example: {
        statusCode: 400,
        message: ['refresh_token should not be empty'],
        error: 'Bad Request',
      },
    },
  })
  @ApiUnauthorizedResponse({
    description: 'Неверный или истекший refresh token',
    schema: {
      example: {
        statusCode: 401,
        message: 'Invalid or expired refresh token',
        error: 'Unauthorized',
      },
    },
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
  @ApiOkResponse({
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
      example: {
        message: 'Если email существует в системе, на него будет отправлено письмо с инструкциями',
      },
    },
  })
  @ApiBadRequestResponse({
    description: 'Некорректный email',
    schema: {
      example: {
        statusCode: 400,
        message: ['email must be an email'],
        error: 'Bad Request',
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
  @ApiOkResponse({
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
      example: {
        message: 'Пароль успешно изменен. Теперь вы можете войти с новым паролем',
      },
    },
  })
  @ApiBadRequestResponse({
    description: 'Неверный или истекший токен, либо некорректный пароль',
    schema: {
      examples: {
        invalidToken: {
          value: {
            statusCode: 400,
            message: 'Invalid or expired reset token',
            error: 'Bad Request',
          },
        },
        weakPassword: {
          value: {
            statusCode: 400,
            message: [
              'new_password must be longer than or equal to 8 characters',
              'new_password must contain at least one uppercase letter, one lowercase letter, and one digit',
            ],
            error: 'Bad Request',
          },
        },
      },
    },
  })
  async resetPassword(
    @Body() resetPasswordDto: ResetPasswordDto,
  ): Promise<{ message: string }> {
    return this.authService.resetPassword(resetPasswordDto);
  }
}
