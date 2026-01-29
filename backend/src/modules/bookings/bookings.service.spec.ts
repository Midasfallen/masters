import { Test, TestingModule } from '@nestjs/testing';
import { BookingsService } from './bookings.service';
import { getRepositoryToken } from '@nestjs/typeorm';
import { Booking, BookingStatus } from './entities/booking.entity';
import { Service } from '../services/entities/service.entity';
import { User } from '../users/entities/user.entity';
import { MasterProfile } from '../masters/entities/master-profile.entity';
import { Review } from '../reviews/entities/review.entity';
import { ReviewReminder } from '../reviews/entities/review-reminder.entity';
import { NotificationsService } from '../notifications/notifications.service';
import { Repository } from 'typeorm';
import { NotFoundException, BadRequestException } from '@nestjs/common';

// Helper: дата через 1 неделю в будущем (валидна для бронирования)
const getValidFutureDate = () => {
  const date = new Date();
  date.setDate(date.getDate() + 7); // +7 дней
  date.setHours(10, 0, 0, 0);
  return date.toISOString();
};

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
      getOne: jest.fn().mockResolvedValue(null),
      getMany: jest.fn().mockResolvedValue([]),
      getManyAndCount: jest.fn().mockResolvedValue([[], 0]),
      leftJoin: jest.fn().mockReturnThis(),
      leftJoinAndSelect: jest.fn().mockReturnThis(),
      setParameter: jest.fn().mockReturnThis(),
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

  const mockReviewRepository = {
    findOne: jest.fn(),
    create: jest.fn(),
    save: jest.fn(),
  };

  const mockReviewReminderRepository = {
    findOne: jest.fn(),
    create: jest.fn(),
    save: jest.fn(),
  };

  const mockNotificationsService = {
    createNotification: jest.fn(),
    sendPushNotification: jest.fn(),
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
        {
          provide: getRepositoryToken(Review),
          useValue: mockReviewRepository,
        },
        {
          provide: getRepositoryToken(ReviewReminder),
          useValue: mockReviewReminderRepository,
        },
        {
          provide: NotificationsService,
          useValue: mockNotificationsService,
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
        start_time: getValidFutureDate(),
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
        start_time: getValidFutureDate(),
      };

      mockServiceRepository.findOne.mockResolvedValue(null);

      await expect(service.create('client-1', createDto)).rejects.toThrow(
        NotFoundException,
      );
    });

    it('should throw BadRequestException when service is not active', async () => {
      const createDto = {
        service_id: 'service-1',
        start_time: getValidFutureDate(),
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
        start_time: getValidFutureDate(),
      };

      mockServiceRepository.findOne.mockResolvedValue(mockService);
      mockMasterProfileRepository.findOne.mockResolvedValue(mockMasterProfile);

      // First call: checkUnreviewedBookings (returns empty)
      mockBookingRepository.createQueryBuilder.mockReturnValueOnce({
        where: jest.fn().mockReturnThis(),
        andWhere: jest.fn().mockReturnThis(),
        getCount: jest.fn().mockResolvedValue(0),
        getOne: jest.fn().mockResolvedValue(null),
        getMany: jest.fn().mockResolvedValue([]),
        getManyAndCount: jest.fn().mockResolvedValue([[], 0]),
        leftJoin: jest.fn().mockReturnThis(),
        leftJoinAndSelect: jest.fn().mockReturnThis(),
        setParameter: jest.fn().mockReturnThis(),
        orderBy: jest.fn().mockReturnThis(),
        skip: jest.fn().mockReturnThis(),
        take: jest.fn().mockReturnThis(),
      });

      // Second call: checkTimeSlotAvailable (returns overlapping booking)
      mockBookingRepository.createQueryBuilder.mockReturnValueOnce({
        where: jest.fn().mockReturnThis(),
        andWhere: jest.fn().mockReturnThis(),
        getCount: jest.fn().mockResolvedValue(1), // Has overlapping bookings!
        getOne: jest.fn().mockResolvedValue(null),
        getMany: jest.fn().mockResolvedValue([]),
        getManyAndCount: jest.fn().mockResolvedValue([[], 0]),
        leftJoin: jest.fn().mockReturnThis(),
        leftJoinAndSelect: jest.fn().mockReturnThis(),
        setParameter: jest.fn().mockReturnThis(),
        orderBy: jest.fn().mockReturnThis(),
        skip: jest.fn().mockReturnThis(),
        take: jest.fn().mockReturnThis(),
      });

      await expect(service.create('client-1', createDto)).rejects.toThrow(
        BadRequestException,
      );
    });
  });

  describe('findAll', () => {
    it('should return paginated bookings for a user', async () => {
      const mockBookings = [mockBooking];

      mockBookingRepository.createQueryBuilder.mockReturnValueOnce({
        where: jest.fn().mockReturnThis(),
        andWhere: jest.fn().mockReturnThis(),
        orderBy: jest.fn().mockReturnThis(),
        skip: jest.fn().mockReturnThis(),
        take: jest.fn().mockReturnThis(),
        getManyAndCount: jest.fn().mockResolvedValue([mockBookings, 1]),
        getCount: jest.fn().mockResolvedValue(0),
        getOne: jest.fn().mockResolvedValue(null),
        getMany: jest.fn().mockResolvedValue([]),
        leftJoin: jest.fn().mockReturnThis(),
        leftJoinAndSelect: jest.fn().mockReturnThis(),
        setParameter: jest.fn().mockReturnThis(),
      });

      const result = await service.findAll('client-1', {});

      expect(result).toHaveProperty('data');
      expect(result).toHaveProperty('total');
      expect(result).toHaveProperty('page');
      expect(result).toHaveProperty('limit');
      expect(result.data).toHaveLength(1);
      expect(result.total).toBe(1);
      expect(mockBookingRepository.createQueryBuilder).toHaveBeenCalled();
    });
  });

  describe('findOne', () => {
    it('should return a booking by id for client', async () => {
      // Booking где client_id совпадает с userId
      const booking = {
        ...mockBooking,
        client_id: 'client-1',
        master_id: 'master-user-1',
        service: mockService,
        client: { id: 'client-1', first_name: 'Client' },
        master: { id: 'master-user-1', first_name: 'Master' },
      };
      mockBookingRepository.findOne.mockResolvedValue(booking);

      const result = await service.findOne('client-1', 'booking-1');

      expect(result).toBeDefined();
      expect(mockBookingRepository.findOne).toHaveBeenCalled();
    });

    it('should return a booking by id for master', async () => {
      // Booking где master_id совпадает с userId
      const masterUserId = 'master-user-1';
      const booking = {
        id: 'booking-1',
        master_id: masterUserId, // Ensure explicit matching
        client_id: 'client-1',
        service_id: 'service-1',
        start_time: new Date('2026-01-15T10:00:00'),
        end_time: new Date('2026-01-15T11:00:00'),
        status: BookingStatus.PENDING,
        total_price: 5000,
        service: mockService,
        client: { id: 'client-1', first_name: 'Client' },
        master: { id: masterUserId, first_name: 'Master' },
      };
      mockBookingRepository.findOne.mockResolvedValue(booking);

      const result = await service.findOne(masterUserId, 'booking-1');

      expect(result).toBeDefined();
      expect(mockBookingRepository.findOne).toHaveBeenCalled();
    });

    it('should throw NotFoundException when booking not found', async () => {
      mockBookingRepository.findOne.mockResolvedValue(null);

      await expect(service.findOne('client-1', 'nonexistent')).rejects.toThrow(
        NotFoundException,
      );
    });
  });
});
