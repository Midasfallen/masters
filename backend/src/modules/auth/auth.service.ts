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
import { User } from '../users/entities/user.entity';
import { RegisterDto } from './dto/register.dto';
import { LoginDto } from './dto/login.dto';
import { AuthResponseDto } from './dto/auth-response.dto';

@Injectable()
export class AuthService {
  constructor(
    @InjectRepository(User)
    private readonly userRepository: Repository<User>,
    private readonly jwtService: JwtService,
  ) {}

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

    // Поиск пользователя
    const user = await this.userRepository.findOne({
      where: { email },
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
      { ...payload, type: 'access' },
      {
        expiresIn: process.env.JWT_EXPIRES_IN || '7d',
        secret: process.env.JWT_SECRET,
      },
    );

    // Refresh token (30 дней)
    const refresh_token = this.jwtService.sign(
      { ...payload, type: 'refresh' },
      {
        expiresIn: '30d',
        secret: process.env.JWT_SECRET,
      },
    );

    // Время жизни токена в секундах (7 дней = 604800 секунд)
    const expires_in = 7 * 24 * 60 * 60;

    return {
      access_token,
      refresh_token,
      token_type: 'Bearer',
      expires_in,
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
