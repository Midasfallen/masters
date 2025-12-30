import { Test, TestingModule } from '@nestjs/testing';
import { BookingsService } from './bookings.service';
import { getRepositoryToken } from '@nestjs/typeorm';
import { Booking, BookingStatus } from './entities/booking.entity';
import { Service } from '../services/entities/service.entity';
import { User } from '../users/entities/user.entity';
import { MasterProfile } from '../masters/entities/master-profile.entity';
import { Repository } from 'typeorm';
import { NotFoundException, BadRequestException } from '@nestjs/common';

describe('BookingsService', () => {
  let service: BookingsService;
  let bookingRepository: Repository<Booking>;
  let serviceRepository: Repository<Service>;

  const mockService = {
    id: 'service-1',
    master_profile_id: 'master-profile-1',
    name: 'Test Service',
    duration_minutes: 60,
    price: 5000,
    is_active: true,
  };

  const mockMasterProfile = {
    id: 'master-profile-1',
    user_id: 'master-user-1',
    is_active: true,
  };

  const mockBooking = {
    id: 'booking-1',
    master_id: 'master-user-1',
    client_id: 'client-1',
    service_id: 'service-1',
    start_time: new Date('2026-01-15T10:00:00'),
    end_time: new Date('2026-01-15T11:00:00'),
    status: BookingStatus.PENDING,
    total_price: 5000,
  };

  const mockBookingRepository = {
    create: jest.fn(),
    save: jest.fn(),
    findOne: jest.fn(),
    find: jest.fn(),
    update: jest.fn(),
    createQueryBuilder: jest.fn(() => ({
      where: jest.fn().mockReturnThis(),
      andWhere: jest.fn().mockReturnThis(),
      getCount: jest.fn().mockResolvedValue(0),
      getMany: jest.fn().mockResolvedValue([]),
      getManyAndCount: jest.fn().mockResolvedValue([[], 0]),
      leftJoinAndSelect: jest.fn().mockReturnThis(),
      orderBy: jest.fn().mockReturnThis(),
      skip: jest.fn().mockReturnThis(),
      take: jest.fn().mockReturnThis(),
    })),
  };

  const mockServiceRepository = {
    findOne: jest.fn(),
  };

  const mockUserRepository = {
    findOne: jest.fn(),
  };

  const mockMasterProfileRepository = {
    findOne: jest.fn(),
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        BookingsService,
        {
          provide: getRepositoryToken(Booking),
          useValue: mockBookingRepository,
        },
        {
          provide: getRepositoryToken(Service),
          useValue: mockServiceRepository,
        },
        {
          provide: getRepositoryToken(User),
          useValue: mockUserRepository,
        },
        {
          provide: getRepositoryToken(MasterProfile),
          useValue: mockMasterProfileRepository,
        },
      ],
    }).compile();

    service = module.get<BookingsService>(BookingsService);
    bookingRepository = module.get<Repository<Booking>>(
      getRepositoryToken(Booking),
    );
    serviceRepository = module.get<Repository<Service>>(
      getRepositoryToken(Service),
    );
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  describe('create', () => {
    it('should create a new booking', async () => {
      const createDto = {
        service_id: 'service-1',
        start_time: '2026-01-15T10:00:00Z',
        comment: 'Test booking',
      };

      mockServiceRepository.findOne.mockResolvedValue(mockService);
      mockMasterProfileRepository.findOne.mockResolvedValue(mockMasterProfile);
      mockBookingRepository.createQueryBuilder().getCount.mockResolvedValue(0);
      mockBookingRepository.create.mockReturnValue(mockBooking);
      mockBookingRepository.save.mockResolvedValue(mockBooking);

      const result = await service.create('client-1', createDto);

      expect(result).toBeDefined();
      expect(mockServiceRepository.findOne).toHaveBeenCalledWith({
        where: { id: createDto.service_id },
      });
      expect(mockBookingRepository.save).toHaveBeenCalled();
    });

    it('should throw NotFoundException when service not found', async () => {
      const createDto = {
        service_id: 'nonexistent-service',
        start_time: '2026-01-15T10:00:00Z',
      };

      mockServiceRepository.findOne.mockResolvedValue(null);

      await expect(service.create('client-1', createDto)).rejects.toThrow(
        NotFoundException,
      );
    });

    it('should throw BadRequestException when service is not active', async () => {
      const createDto = {
        service_id: 'service-1',
        start_time: '2026-01-15T10:00:00Z',
      };

      mockServiceRepository.findOne.mockResolvedValue({
        ...mockService,
        is_active: false,
      });

      await expect(service.create('client-1', createDto)).rejects.toThrow(
        BadRequestException,
      );
    });

    it('should throw BadRequestException when time is in the past', async () => {
      const createDto = {
        service_id: 'service-1',
        start_time: '2020-01-15T10:00:00Z', // прошлое
      };

      mockServiceRepository.findOne.mockResolvedValue(mockService);
      mockMasterProfileRepository.findOne.mockResolvedValue(mockMasterProfile);

      await expect(service.create('client-1', createDto)).rejects.toThrow(
        BadRequestException,
      );
    });

    it('should throw BadRequestException when time slot is not available', async () => {
      const createDto = {
        service_id: 'service-1',
        start_time: '2026-01-15T10:00:00Z',
      };

      mockServiceRepository.findOne.mockResolvedValue(mockService);
      mockMasterProfileRepository.findOne.mockResolvedValue(mockMasterProfile);
      // Есть пересечение с существующим бронированием
      mockBookingRepository.createQueryBuilder().getCount.mockResolvedValue(1);

      await expect(service.create('client-1', createDto)).rejects.toThrow(
        BadRequestException,
      );
    });
  });

  describe('findAll', () => {
    it('should return all bookings for a user', async () => {
      const mockBookings = [mockBooking];
      mockBookingRepository
        .createQueryBuilder()
        .getMany.mockResolvedValue(mockBookings);

      const result = await service.findAll('client-1', {});

      expect(result).toEqual(mockBookings);
      expect(mockBookingRepository.createQueryBuilder).toHaveBeenCalled();
    });
  });

  describe('findOne', () => {
    it('should return a booking by id', async () => {
      // Booking где client_id совпадает с userId
      const booking = { ...mockBooking, client_id: 'client-1' };
      mockBookingRepository.findOne.mockResolvedValue(booking);

      const result = await service.findOne('booking-1', 'client-1');

      expect(result).toBeDefined();
      expect(mockBookingRepository.findOne).toHaveBeenCalled();
    });

    it('should throw NotFoundException when booking not found', async () => {
      mockBookingRepository.findOne.mockResolvedValue(null);

      await expect(service.findOne('nonexistent', 'client-1')).rejects.toThrow(
        NotFoundException,
      );
    });
  });
});
