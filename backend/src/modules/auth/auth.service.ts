import {
  Injectable,
  UnauthorizedException,
  ConflictException,
  BadRequestException,
} from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import * as bcrypt from 'bcrypt';
import { v4 as uuidv4 } from 'uuid';
import { User } from '../users/entities/user.entity';
import { RegisterDto } from './dto/register.dto';
import { LoginDto } from './dto/login.dto';
import { ForgotPasswordDto } from './dto/forgot-password.dto';
import { ResetPasswordDto } from './dto/reset-password.dto';
import { AuthResponseDto } from './dto/auth-response.dto';

@Injectable()
export class AuthService {
  // Temporary in-memory storage for reset tokens
  // TODO: Replace with Redis in production
  private resetTokens = new Map<string, { userId: string; expires: Date }>();

  constructor(
    @InjectRepository(User)
    private readonly userRepository: Repository<User>,
    private readonly jwtService: JwtService,
  ) {
    // Clean expired tokens every hour
    setInterval(() => this.cleanExpiredTokens(), 60 * 60 * 1000);
  }

  /**
   * Регистрация нового пользователя
   * В v2.0 все пользователи - клиенты по умолчанию (is_master = false)
   */
  async register(registerDto: RegisterDto): Promise<AuthResponseDto> {
    const { email, phone, password, first_name, last_name, language } =
      registerDto;

    // Проверка существования пользователя
    const existingUser = await this.userRepository.findOne({
      where: [{ email }, ...(phone ? [{ phone }] : [])],
    });

    if (existingUser) {
      if (existingUser.email === email) {
        throw new ConflictException('Пользователь с таким email уже существует');
      }
      if (phone && existingUser.phone === phone) {
        throw new ConflictException(
          'Пользователь с таким номером телефона уже существует',
        );
      }
    }

    // Хеширование пароля
    const password_hash = await this.hashPassword(password);

    // Создание пользователя
    const user = this.userRepository.create({
      email,
      phone,
      password_hash,
      first_name,
      last_name,
      language: language || 'en',
      is_master: false, // v2.0: все пользователи - клиенты по умолчанию
      master_profile_completed: false,
    });

    await this.userRepository.save(user);

    // Генерация токенов
    return this.generateAuthResponse(user);
  }

  /**
   * Вход пользователя
   */
  async login(loginDto: LoginDto): Promise<AuthResponseDto> {
    const { email, password } = loginDto;

    // Поиск пользователя (с password_hash для проверки)
    const user = await this.userRepository.findOne({
      where: { email },
      select: ['id', 'email', 'password_hash', 'first_name', 'last_name', 'avatar_url', 'is_master', 'is_verified', 'is_premium', 'is_admin'], // Added is_admin for AdminGuard
    });

    if (!user) {
      throw new UnauthorizedException('Неверный email или пароль');
    }

    // Проверка пароля
    const isPasswordValid = await this.comparePasswords(
      password,
      user.password_hash,
    );

    if (!isPasswordValid) {
      throw new UnauthorizedException('Неверный email или пароль');
    }

    // Генерация токенов
    return this.generateAuthResponse(user);
  }

  /**
   * Обновление access token по refresh token
   */
  async refreshToken(refreshToken: string): Promise<AuthResponseDto> {
    try {
      // Верификация refresh token
      const payload = this.jwtService.verify(refreshToken, {
        secret: process.env.JWT_SECRET,
      });

      // Проверка типа токена
      if (payload.type !== 'refresh') {
        throw new UnauthorizedException('Неверный тип токена');
      }

      // Поиск пользователя
      const user = await this.userRepository.findOne({
        where: { id: payload.sub },
      });

      if (!user) {
        throw new UnauthorizedException('Пользователь не найден');
      }

      // Генерация новых токенов
      return this.generateAuthResponse(user);
    } catch (error) {
      throw new UnauthorizedException('Неверный или истекший refresh token');
    }
  }

  /**
   * Forgot Password - отправка токена сброса
   */
  async forgotPassword(forgotPasswordDto: ForgotPasswordDto): Promise<{ message: string }> {
    const { email } = forgotPasswordDto;

    // Поиск пользователя
    const user = await this.userRepository.findOne({
      where: { email },
    });

    // Всегда возвращаем success, даже если пользователь не найден (security best practice)
    if (!user) {
      return {
        message: 'Если email существует в системе, на него будет отправлено письмо с инструкциями',
      };
    }

    // Генерация токена сброса
    const resetToken = uuidv4();
    const expires = new Date();
    expires.setHours(expires.getHours() + 1); // Токен действителен 1 час

    // Сохранение токена
    this.resetTokens.set(resetToken, {
      userId: user.id,
      expires,
    });

    // TODO: Отправка email с токеном через MailHog/SMTP
    // В реальной системе здесь будет:
    // await this.emailService.sendPasswordResetEmail(user.email, resetToken);

    console.log(`[AUTH] Password reset token for ${email}: ${resetToken}`);
    console.log(`[AUTH] Reset link: ${process.env.FRONTEND_URL}/reset-password?token=${resetToken}`);

    return {
      message: 'Если email существует в системе, на него будет отправлено письмо с инструкциями',
    };
  }

  /**
   * Reset Password - сброс пароля по токену
   */
  async resetPassword(resetPasswordDto: ResetPasswordDto): Promise<{ message: string }> {
    const { reset_token, new_password } = resetPasswordDto;

    // Проверка токена
    const tokenData = this.resetTokens.get(reset_token);

    if (!tokenData) {
      throw new BadRequestException('Неверный или истекший токен сброса пароля');
    }

    // Проверка времени истечения
    if (new Date() > tokenData.expires) {
      this.resetTokens.delete(reset_token);
      throw new BadRequestException('Токен истек. Пожалуйста, запросите новый');
    }

    // Поиск пользователя
    const user = await this.userRepository.findOne({
      where: { id: tokenData.userId },
    });

    if (!user) {
      throw new BadRequestException('Пользователь не найден');
    }

    // Обновление пароля
    user.password_hash = await this.hashPassword(new_password);
    await this.userRepository.save(user);

    // Удаление использованного токена
    this.resetTokens.delete(reset_token);

    console.log(`[AUTH] Password reset successful for user ${user.email}`);

    return {
      message: 'Пароль успешно изменен. Теперь вы можете войти с новым паролем',
    };
  }

  /**
   * Валидация пользователя по ID (для JWT Strategy)
   */
  async validateUser(userId: string): Promise<User> {
    const user = await this.userRepository.findOne({
      where: { id: userId },
    });

    if (!user) {
      throw new UnauthorizedException('Пользователь не найден');
    }

    return user;
  }

  /**
   * Очистка истекших токенов сброса
   */
  private cleanExpiredTokens(): void {
    const now = new Date();
    for (const [token, data] of this.resetTokens.entries()) {
      if (now > data.expires) {
        this.resetTokens.delete(token);
      }
    }
  }

  /**
   * Хеширование пароля
   */
  private async hashPassword(password: string): Promise<string> {
    const saltRounds = 10;
    return bcrypt.hash(password, saltRounds);
  }

  /**
   * Сравнение паролей
   */
  private async comparePasswords(
    password: string,
    hash: string,
  ): Promise<boolean> {
    return bcrypt.compare(password, hash);
  }

  /**
   * Генерация JWT токенов и ответа аутентификации
   */
  private async generateAuthResponse(user: User): Promise<AuthResponseDto> {
    const payload = {
      sub: user.id,
      email: user.email,
      is_master: user.is_master,
    };

    // Access token (7 дней по умолчанию)
    const access_token = this.jwtService.sign(
      { ...payload, type: 'access', jti: uuidv4() },
      {
        expiresIn: process.env.JWT_EXPIRES_IN || '7d',
        secret: process.env.JWT_SECRET,
      },
    );

    // Refresh token (30 дней)
    const refresh_token = this.jwtService.sign(
      { ...payload, type: 'refresh', jti: uuidv4() },
      {
        expiresIn: '30d',
        secret: process.env.JWT_SECRET,
      },
    );

    return {
      access_token,
      refresh_token,
      token_type: 'Bearer',
      expires_in: 7 * 24 * 60 * 60, // 7 дней в секундах
      user: {
        id: user.id,
        email: user.email,
        first_name: user.first_name,
        last_name: user.last_name,
        avatar_url: user.avatar_url,
        is_master: user.is_master,
        is_verified: user.is_verified,
        is_premium: user.is_premium,
      },
    };
  }
}
