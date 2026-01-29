import { Test, TestingModule } from '@nestjs/testing';
import { ServicesService } from './services.service';
import { getRepositoryToken } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Service } from './entities/service.entity';
import { User } from '../users/entities/user.entity';
import { MasterProfile } from '../masters/entities/master-profile.entity';
import {
  NotFoundException,
  ForbiddenException,
  BadRequestException,
} from '@nestjs/common';

describe('ServicesService', () => {
  let service: ServicesService;
  let serviceRepository: Repository<Service>;
  let userRepository: Repository<User>;
  let masterProfileRepository: Repository<MasterProfile>;

  const mockUserId = 'user-uuid';
  const mockMasterProfileId = 'master-profile-uuid';
  const mockServiceId = 'service-uuid';
  const mockCategoryId = 'category-uuid';

  // Mock entities use snake_case (as in database)
  const mockUser: Partial<User> = {
    id: mockUserId,
    email: 'master@example.com',
    is_master: true,
    master_profile_completed: true,
  };

  const mockMasterProfile: Partial<MasterProfile> = {
    id: mockMasterProfileId,
    user_id: mockUserId,
    category_ids: [mockCategoryId],
  };

  const mockService: Partial<Service> = {
    id: mockServiceId,
    master_id: mockMasterProfileId,
    category_id: mockCategoryId,
    name: 'Мужская стрижка',
    description: 'Классическая мужская стрижка',
    price: 1500,
    currency: 'RUB',
    duration_minutes: 60,
    is_active: true,
    is_bookable_online: true,
    is_mobile: false,
    is_in_salon: true,
    tags: ['стрижка', 'мужская'],
    photo_urls: [],
    display_order: 0,
    bookings_count: 0,
    average_rating: 0,
    created_at: new Date(),
    updated_at: new Date(),
  };

  // Expected response DTO (camelCase - from mapper)
  const expectedServiceResponse = {
    id: mockServiceId,
    masterId: mockMasterProfileId,
    categoryId: mockCategoryId,
    subcategoryId: undefined,
    name: 'Мужская стрижка',
    description: 'Классическая мужская стрижка',
    price: 1500,
    currency: 'RUB',
    priceFrom: null,
    priceTo: null,
    durationMinutes: 60,
    isActive: true,
    isBookableOnline: true,
    isMobile: false,
    isInSalon: true,
    tags: ['стрижка', 'мужская'],
    photoUrls: [],
    displayOrder: 0,
    bookingsCount: 0,
    averageRating: 0,
  };

  const mockServiceRepository = {
    create: jest.fn(),
    save: jest.fn(),
    findOne: jest.fn(),
    remove: jest.fn(),
    createQueryBuilder: jest.fn(),
  };

  const mockUserRepository = {
    findOne: jest.fn(),
  };

  const mockMasterProfileRepository = {
    findOne: jest.fn(),
  };

  const mockQueryBuilder = {
    where: jest.fn().mockReturnThis(),
    andWhere: jest.fn().mockReturnThis(),
    orderBy: jest.fn().mockReturnThis(),
    addOrderBy: jest.fn().mockReturnThis(),
    skip: jest.fn().mockReturnThis(),
    take: jest.fn().mockReturnThis(),
    getCount: jest.fn(),
    getMany: jest.fn(),
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        ServicesService,
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

    service = module.get<ServicesService>(ServicesService);
    serviceRepository = module.get<Repository<Service>>(
      getRepositoryToken(Service),
    );
    userRepository = module.get<Repository<User>>(getRepositoryToken(User));
    masterProfileRepository = module.get<Repository<MasterProfile>>(
      getRepositoryToken(MasterProfile),
    );
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  describe('create', () => {
    const createServiceDto = {
      category_id: mockCategoryId,
      name: 'Мужская стрижка',
      description: 'Классическая стрижка',
      price: 1500,
      duration_minutes: 60,
    };

    it('should create a service successfully', async () => {
      mockUserRepository.findOne.mockResolvedValue(mockUser);
      mockMasterProfileRepository.findOne.mockResolvedValue(mockMasterProfile);
      mockServiceRepository.create.mockReturnValue(mockService);
      mockServiceRepository.save.mockResolvedValue(mockService);

      const result = await service.create(mockUserId, createServiceDto as any);

      expect(result.id).toEqual(mockServiceId);
      expect(result.name).toEqual('Мужская стрижка');
      expect(mockUserRepository.findOne).toHaveBeenCalledWith({
        where: { id: mockUserId },
      });
      expect(mockMasterProfileRepository.findOne).toHaveBeenCalledWith({
        where: { user_id: mockUserId },
      });
      expect(mockServiceRepository.save).toHaveBeenCalled();
    });

    it('should throw ForbiddenException if user is not a master', async () => {
      mockUserRepository.findOne.mockResolvedValue({
        ...mockUser,
        is_master: false,
      });

      await expect(
        service.create(mockUserId, createServiceDto as any),
      ).rejects.toThrow(ForbiddenException);
    });

    it('should throw ForbiddenException if master profile is not completed', async () => {
      mockUserRepository.findOne.mockResolvedValue({
        ...mockUser,
        master_profile_completed: false,
      });

      await expect(
        service.create(mockUserId, createServiceDto as any),
      ).rejects.toThrow(ForbiddenException);
    });

    it('should throw NotFoundException if master profile not found', async () => {
      mockUserRepository.findOne.mockResolvedValue(mockUser);
      mockMasterProfileRepository.findOne.mockResolvedValue(null);

      await expect(
        service.create(mockUserId, createServiceDto as any),
      ).rejects.toThrow(NotFoundException);
    });

    it('should throw BadRequestException if category not in master profile', async () => {
      mockUserRepository.findOne.mockResolvedValue(mockUser);
      mockMasterProfileRepository.findOne.mockResolvedValue({
        ...mockMasterProfile,
        category_ids: ['other-category-uuid'],
      });

      await expect(
        service.create(mockUserId, createServiceDto as any),
      ).rejects.toThrow(BadRequestException);
    });

    it('should throw BadRequestException if price_from > price_to', async () => {
      mockUserRepository.findOne.mockResolvedValue(mockUser);
      mockMasterProfileRepository.findOne.mockResolvedValue(mockMasterProfile);

      const invalidDto = {
        ...createServiceDto,
        price_from: 2000,
        price_to: 1000,
      };

      await expect(
        service.create(mockUserId, invalidDto as any),
      ).rejects.toThrow(BadRequestException);
    });
  });

  describe('getMyServices', () => {
    const filterDto = { page: 1, limit: 10, skip: 0, take: 10 };

    it('should return services of current master', async () => {
      mockMasterProfileRepository.findOne.mockResolvedValue(mockMasterProfile);
      mockServiceRepository.createQueryBuilder.mockReturnValue(
        mockQueryBuilder,
      );
      mockQueryBuilder.getCount.mockResolvedValue(1);
      mockQueryBuilder.getMany.mockResolvedValue([mockService]);

      const result = await service.getMyServices(mockUserId, filterDto as any);

      expect(result.data).toHaveLength(1);
      expect(result.meta.total).toBe(1);
      expect(mockMasterProfileRepository.findOne).toHaveBeenCalledWith({
        where: { user_id: mockUserId },
      });
    });

    it('should throw NotFoundException if master profile not found', async () => {
      mockMasterProfileRepository.findOne.mockResolvedValue(null);

      await expect(
        service.getMyServices(mockUserId, filterDto as any),
      ).rejects.toThrow(NotFoundException);
    });
  });

  describe('getServicesByMaster', () => {
    const filterDto = { page: 1, limit: 10, skip: 0, take: 10 };

    it('should return services with filters', async () => {
      mockServiceRepository.createQueryBuilder.mockReturnValue(
        mockQueryBuilder,
      );
      mockQueryBuilder.getCount.mockResolvedValue(1);
      mockQueryBuilder.getMany.mockResolvedValue([mockService]);

      const result = await service.getServicesByMaster(
        mockMasterProfileId,
        filterDto as any,
      );

      expect(result.data).toHaveLength(1);
      expect(result.meta.total).toBe(1);
      expect(mockQueryBuilder.where).toHaveBeenCalledWith(
        'service.master_id = :masterId',
        { masterId: mockMasterProfileId },
      );
    });

    it('should apply category filter', async () => {
      mockServiceRepository.createQueryBuilder.mockReturnValue(
        mockQueryBuilder,
      );
      mockQueryBuilder.getCount.mockResolvedValue(0);
      mockQueryBuilder.getMany.mockResolvedValue([]);

      const filterWithCategory = {
        ...filterDto,
        category_id: mockCategoryId,
      };

      await service.getServicesByMaster(
        mockMasterProfileId,
        filterWithCategory as any,
      );

      expect(mockQueryBuilder.andWhere).toHaveBeenCalledWith(
        'service.category_id = :categoryId',
        { categoryId: mockCategoryId },
      );
    });

    it('should apply is_active filter', async () => {
      mockServiceRepository.createQueryBuilder.mockReturnValue(
        mockQueryBuilder,
      );
      mockQueryBuilder.getCount.mockResolvedValue(0);
      mockQueryBuilder.getMany.mockResolvedValue([]);

      const filterWithActive = { ...filterDto, is_active: true };

      await service.getServicesByMaster(
        mockMasterProfileId,
        filterWithActive as any,
      );

      expect(mockQueryBuilder.andWhere).toHaveBeenCalledWith(
        'service.is_active = :isActive',
        { isActive: true },
      );
    });
  });

  describe('findById', () => {
    it('should return service by id', async () => {
      mockServiceRepository.findOne.mockResolvedValue(mockService);

      const result = await service.findById(mockServiceId);

      expect(result.id).toEqual(mockServiceId);
      expect(result.name).toEqual('Мужская стрижка');
      expect(result.masterId).toEqual(mockMasterProfileId);
      expect(mockServiceRepository.findOne).toHaveBeenCalledWith({
        where: { id: mockServiceId },
      });
    });

    it('should throw NotFoundException if service not found', async () => {
      mockServiceRepository.findOne.mockResolvedValue(null);

      await expect(service.findById(mockServiceId)).rejects.toThrow(
        NotFoundException,
      );
    });
  });

  describe('update', () => {
    const updateDto = {
      name: 'Обновленная стрижка',
      price: 1800,
    };

    it('should update service successfully', async () => {
      mockServiceRepository.findOne.mockResolvedValue(mockService);
      mockMasterProfileRepository.findOne.mockResolvedValue(mockMasterProfile);
      mockServiceRepository.save.mockResolvedValue({
        ...mockService,
        ...updateDto,
      });

      const result = await service.update(
        mockUserId,
        mockServiceId,
        updateDto as any,
      );

      expect(result.name).toBe(updateDto.name);
      expect(result.price).toBe(updateDto.price);
      expect(mockServiceRepository.save).toHaveBeenCalled();
    });

    it('should throw ForbiddenException if not owner', async () => {
      mockServiceRepository.findOne.mockResolvedValue(mockService);
      mockMasterProfileRepository.findOne.mockResolvedValue({
        ...mockMasterProfile,
        id: 'different-master-id',
      });

      await expect(
        service.update(mockUserId, mockServiceId, updateDto as any),
      ).rejects.toThrow(ForbiddenException);
    });

    it('should throw BadRequestException if new category not in master profile', async () => {
      mockServiceRepository.findOne.mockResolvedValue(mockService);
      mockMasterProfileRepository.findOne.mockResolvedValue(mockMasterProfile);

      const updateWithCategory = {
        ...updateDto,
        category_id: 'other-category-uuid',
      };

      await expect(
        service.update(mockUserId, mockServiceId, updateWithCategory as any),
      ).rejects.toThrow(BadRequestException);
    });

    it('should throw BadRequestException if price_from > price_to', async () => {
      mockServiceRepository.findOne.mockResolvedValue(mockService);
      mockMasterProfileRepository.findOne.mockResolvedValue(mockMasterProfile);

      const invalidUpdate = {
        price_from: 2000,
        price_to: 1000,
      };

      await expect(
        service.update(mockUserId, mockServiceId, invalidUpdate as any),
      ).rejects.toThrow(BadRequestException);
    });
  });

  describe('remove', () => {
    it('should remove service successfully', async () => {
      mockServiceRepository.findOne.mockResolvedValue(mockService);
      mockMasterProfileRepository.findOne.mockResolvedValue(mockMasterProfile);
      mockServiceRepository.remove.mockResolvedValue(mockService);

      await service.remove(mockUserId, mockServiceId);

      expect(mockServiceRepository.remove).toHaveBeenCalledWith(mockService);
    });

    it('should throw ForbiddenException if not owner', async () => {
      mockServiceRepository.findOne.mockResolvedValue(mockService);
      mockMasterProfileRepository.findOne.mockResolvedValue({
        ...mockMasterProfile,
        id: 'different-master-id',
      });

      await expect(service.remove(mockUserId, mockServiceId)).rejects.toThrow(
        ForbiddenException,
      );
    });
  });

  describe('deactivate', () => {
    it('should deactivate service successfully', async () => {
      mockServiceRepository.findOne.mockResolvedValue(mockService);
      mockMasterProfileRepository.findOne.mockResolvedValue(mockMasterProfile);
      mockServiceRepository.save.mockResolvedValue({
        ...mockService,
        is_active: false,
      });

      const result = await service.deactivate(mockUserId, mockServiceId);

      // Response uses camelCase via mapper
      expect(result.isActive).toBe(false);
      expect(mockServiceRepository.save).toHaveBeenCalled();
    });

    it('should throw ForbiddenException if not owner', async () => {
      mockServiceRepository.findOne.mockResolvedValue(mockService);
      mockMasterProfileRepository.findOne.mockResolvedValue({
        ...mockMasterProfile,
        id: 'different-master-id',
      });

      await expect(
        service.deactivate(mockUserId, mockServiceId),
      ).rejects.toThrow(ForbiddenException);
    });
  });

  describe('activate', () => {
    it('should activate service successfully', async () => {
      const inactiveService = { ...mockService, is_active: false };
      mockServiceRepository.findOne.mockResolvedValue(inactiveService);
      mockMasterProfileRepository.findOne.mockResolvedValue(mockMasterProfile);
      mockServiceRepository.save.mockResolvedValue({
        ...inactiveService,
        is_active: true,
      });

      const result = await service.activate(mockUserId, mockServiceId);

      // Response uses camelCase via mapper
      expect(result.isActive).toBe(true);
      expect(mockServiceRepository.save).toHaveBeenCalled();
    });

    it('should throw ForbiddenException if not owner', async () => {
      mockServiceRepository.findOne.mockResolvedValue(mockService);
      mockMasterProfileRepository.findOne.mockResolvedValue({
        ...mockMasterProfile,
        id: 'different-master-id',
      });

      await expect(
        service.activate(mockUserId, mockServiceId),
      ).rejects.toThrow(ForbiddenException);
    });
  });
});
