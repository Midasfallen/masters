import { Injectable, UnauthorizedException } from '@nestjs/common';
import { PassportStrategy } from '@nestjs/passport';
import { ExtractJwt, Strategy } from 'passport-jwt';
import { AuthService } from '../auth.service';

@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy) {
  constructor(private readonly authService: AuthService) {
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      ignoreExpiration: false,
      secretOrKey: process.env.JWT_SECRET || 'your-super-secret-jwt-key',
    });
  }

  async validate(payload: any) {
    // Проверка типа токена (должен быть access)
    if (payload.type !== 'access') {
      throw new UnauthorizedException('Неверный тип токена');
    }

    // Получение пользователя из БД
    const user = await this.authService.validateUser(payload.sub);

    // Возвращаем пользователя (будет доступен через @CurrentUser() декоратор)
    return user;
  }
}
