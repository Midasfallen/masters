import { Test, TestingModule } from '@nestjs/testing';
import { AuthService } from './auth.service';
import { UsersService } from '../users/users.service';
import { JwtService } from '@nestjs/jwt';
import { UnauthorizedException } from '@nestjs/common';
import * as bcrypt from 'bcrypt';

describe('AuthService', () => {
  let service: AuthService;
  let usersService: UsersService;
  let jwtService: JwtService;

  const mockUser = {
    id: '1',
    email: 'test@example.com',
    password_hash: 'hashedPassword',
    first_name: 'Test',
    last_name: 'User',
  };

  const mockUsersService = {
    findByEmail: jest.fn(),
    create: jest.fn(),
  };

  const mockJwtService = {
    sign: jest.fn(),
    verify: jest.fn(),
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        AuthService,
        {
          provide: UsersService,
          useValue: mockUsersService,
        },
        {
          provide: JwtService,
          useValue: mockJwtService,
        },
      ],
    }).compile();

    service = module.get<AuthService>(AuthService);
    usersService = module.get<UsersService>(UsersService);
    jwtService = module.get<JwtService>(JwtService);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  describe('validateUser', () => {
    it('should return user without password when credentials are valid', async () => {
      jest.spyOn(bcrypt, 'compare').mockResolvedValue(true as never);
      mockUsersService.findByEmail.mockResolvedValue(mockUser);

      const result = await service.validateUser('test@example.com', 'password');

      expect(result).toBeDefined();
      expect(result.password_hash).toBeUndefined();
      expect(mockUsersService.findByEmail).toHaveBeenCalledWith('test@example.com');
    });

    it('should throw UnauthorizedException when user not found', async () => {
      mockUsersService.findByEmail.mockResolvedValue(null);

      await expect(
        service.validateUser('wrong@example.com', 'password'),
      ).rejects.toThrow(UnauthorizedException);
    });

    it('should throw UnauthorizedException when password is invalid', async () => {
      jest.spyOn(bcrypt, 'compare').mockResolvedValue(false as never);
      mockUsersService.findByEmail.mockResolvedValue(mockUser);

      await expect(
        service.validateUser('test@example.com', 'wrongpassword'),
      ).rejects.toThrow(UnauthorizedException);
    });
  });

  describe('login', () => {
    it('should return access token and refresh token', async () => {
      const tokens = {
        access_token: 'access_token',
        refresh_token: 'refresh_token',
      };
      mockJwtService.sign.mockReturnValue('token');

      const result = await service.login(mockUser);

      expect(result).toHaveProperty('access_token');
      expect(result).toHaveProperty('refresh_token');
      expect(mockJwtService.sign).toHaveBeenCalledTimes(2);
    });
  });

  describe('register', () => {
    it('should create new user and return tokens', async () => {
      const registerDto = {
        email: 'new@example.com',
        password: 'Password123',
        first_name: 'New',
        last_name: 'User',
      };

      jest.spyOn(bcrypt, 'hash').mockResolvedValue('hashedPassword' as never);
      mockUsersService.create.mockResolvedValue({
        ...mockUser,
        email: registerDto.email,
      });
      mockJwtService.sign.mockReturnValue('token');

      const result = await service.register(registerDto);

      expect(result).toHaveProperty('access_token');
      expect(result).toHaveProperty('refresh_token');
      expect(result).toHaveProperty('user');
      expect(mockUsersService.create).toHaveBeenCalled();
    });
  });

  describe('refreshToken', () => {
    it('should return new tokens when refresh token is valid', async () => {
      const payload = { sub: '1', email: 'test@example.com' };
      mockJwtService.verify.mockReturnValue(payload);
      mockJwtService.sign.mockReturnValue('new_token');

      const result = await service.refreshToken('valid_refresh_token');

      expect(result).toHaveProperty('access_token');
      expect(result).toHaveProperty('refresh_token');
      expect(mockJwtService.verify).toHaveBeenCalledWith('valid_refresh_token');
    });

    it('should throw UnauthorizedException when refresh token is invalid', async () => {
      mockJwtService.verify.mockImplementation(() => {
        throw new Error('Invalid token');
      });

      await expect(service.refreshToken('invalid_token')).rejects.toThrow(
        UnauthorizedException,
      );
    });
  });
});
