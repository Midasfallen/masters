import { Test, TestingModule } from '@nestjs/testing';
import { BookingsService } from './bookings.service';
import { getRepositoryToken } from '@nestjs/typeorm';
import { Booking } from './entities/booking.entity';
import { Repository } from 'typeorm';
import { NotFoundException, BadRequestException } from '@nestjs/common';

describe('BookingsService', () => {
  let service: BookingsService;
  let repository: Repository<Booking>;

  const mockBooking = {
    id: '1',
    master_id: 'master1',
    client_id: 'client1',
    service_id: 'service1',
    start_time: new Date('2026-01-15T10:00:00'),
    end_time: new Date('2026-01-15T11:00:00'),
    status: 'pending',
    total_price: 5000,
  };

  const mockRepository = {
    create: jest.fn(),
    save: jest.fn(),
    findOne: jest.fn(),
    find: jest.fn(),
    update: jest.fn(),
    delete: jest.fn(),
    createQueryBuilder: jest.fn(() => ({
      where: jest.fn().mockReturnThis(),
      andWhere: jest.fn().mockReturnThis(),
      getMany: jest.fn().mockResolvedValue([]),
    })),
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        BookingsService,
        {
          provide: getRepositoryToken(Booking),
          useValue: mockRepository,
        },
      ],
    }).compile();

    service = module.get<BookingsService>(BookingsService);
    repository = module.get<Repository<Booking>>(getRepositoryToken(Booking));
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
        master_id: 'master1',
        service_id: 'service1',
        start_time: new Date('2026-01-15T10:00:00'),
        comment: 'Test booking',
      };

      mockRepository.create.mockReturnValue(mockBooking);
      mockRepository.save.mockResolvedValue(mockBooking);

      const result = await service.create(createDto, 'client1');

      expect(result).toEqual(mockBooking);
      expect(mockRepository.create).toHaveBeenCalled();
      expect(mockRepository.save).toHaveBeenCalled();
    });

    it('should throw BadRequestException when time slot is not available', async () => {
      const createDto = {
        master_id: 'master1',
        service_id: 'service1',
        start_time: new Date('2026-01-15T10:00:00'),
      };

      // Mock overlapping booking
      mockRepository.createQueryBuilder().getMany.mockResolvedValue([mockBooking]);

      await expect(service.create(createDto, 'client1')).rejects.toThrow(
        BadRequestException,
      );
    });
  });

  describe('findOne', () => {
    it('should return a booking by id', async () => {
      mockRepository.findOne.mockResolvedValue(mockBooking);

      const result = await service.findOne('1');

      expect(result).toEqual(mockBooking);
      expect(mockRepository.findOne).toHaveBeenCalledWith({
        where: { id: '1' },
        relations: expect.any(Array),
      });
    });

    it('should throw NotFoundException when booking not found', async () => {
      mockRepository.findOne.mockResolvedValue(null);

      await expect(service.findOne('999')).rejects.toThrow(NotFoundException);
    });
  });

  describe('confirm', () => {
    it('should confirm a pending booking', async () => {
      const pendingBooking = { ...mockBooking, status: 'pending' };
      const confirmedBooking = { ...mockBooking, status: 'confirmed' };

      mockRepository.findOne.mockResolvedValue(pendingBooking);
      mockRepository.save.mockResolvedValue(confirmedBooking);

      const result = await service.confirm('1', 'master1');

      expect(result.status).toBe('confirmed');
      expect(mockRepository.save).toHaveBeenCalled();
    });

    it('should throw BadRequestException when booking is not pending', async () => {
      const confirmedBooking = { ...mockBooking, status: 'confirmed' };
      mockRepository.findOne.mockResolvedValue(confirmedBooking);

      await expect(service.confirm('1', 'master1')).rejects.toThrow(
        BadRequestException,
      );
    });
  });

  describe('cancel', () => {
    it('should cancel a booking', async () => {
      const cancelledBooking = { ...mockBooking, status: 'cancelled' };
      mockRepository.findOne.mockResolvedValue(mockBooking);
      mockRepository.save.mockResolvedValue(cancelledBooking);

      const result = await service.cancel('1', 'client1');

      expect(result.status).toBe('cancelled');
      expect(mockRepository.save).toHaveBeenCalled();
    });

    it('should throw BadRequestException when cancelling less than 1 hour before start', async () => {
      const soonBooking = {
        ...mockBooking,
        start_time: new Date(Date.now() + 30 * 60 * 1000), // 30 minutes from now
      };
      mockRepository.findOne.mockResolvedValue(soonBooking);

      await expect(service.cancel('1', 'client1')).rejects.toThrow(
        BadRequestException,
      );
    });
  });

  describe('getAvailableSlots', () => {
    it('should return available time slots', async () => {
      const date = new Date('2026-01-15');
      mockRepository.createQueryBuilder().getMany.mockResolvedValue([]);

      const result = await service.getAvailableSlots('master1', date);

      expect(result).toBeDefined();
      expect(Array.isArray(result)).toBe(true);
    });
  });
});
