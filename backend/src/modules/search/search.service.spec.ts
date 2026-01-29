import { Test, TestingModule } from '@nestjs/testing';
import { getRepositoryToken } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { User } from '../users/entities/user.entity';
import { MasterProfile } from '../masters/entities/master-profile.entity';
import { Service } from '../services/entities/service.entity';

// Mock MeiliSearch before importing SearchService
const mockMeiliIndex = {
  search: jest.fn(),
  updateSettings: jest.fn().mockResolvedValue({}),
  addDocuments: jest.fn().mockResolvedValue({}),
};

const mockMeiliClient = {
  index: jest.fn().mockReturnValue(mockMeiliIndex),
};

jest.mock('meilisearch', () => ({
  MeiliSearch: jest.fn().mockImplementation(() => mockMeiliClient),
}));

// Import SearchService AFTER mocking meilisearch
import { SearchService } from './search.service';

describe('SearchService', () => {
  let service: SearchService;
  let userRepository: Repository<User>;
  let masterProfileRepository: Repository<MasterProfile>;
  let serviceRepository: Repository<Service>;

  const mockUser = {
    id: '550e8400-e29b-41d4-a716-446655440000',
    email: 'master@example.com',
    first_name: 'Иван',
    last_name: 'Петров',
    avatar_url: 'https://example.com/avatar.jpg',
    is_master: true,
    rating: 4.5,
    reviews_count: 10,
    created_at: new Date(),
  };

  const mockMasterProfile = {
    id: 'profile-uuid',
    user_id: '550e8400-e29b-41d4-a716-446655440000',
    business_name: 'Салон красоты',
    bio: 'Опытный парикмахер',
    category_ids: ['cat-uuid-1'],
    tags: ['стрижка', 'окрашивание'],
    location_address: 'Москва, Тверская 1',
    location_lat: 55.7558,
    location_lng: 37.6173,
    is_active: true,
  };

  const mockService = {
    id: 'service-uuid',
    master_id: 'profile-uuid',
    category_id: 'cat-uuid-1',
    name: 'Мужская стрижка',
    description: 'Классическая мужская стрижка',
    price: 1500,
    duration_minutes: 60,
    tags: ['стрижка', 'мужская'],
    photo_urls: [],
    is_active: true,
    bookings_count: 5,
    average_rating: 4.8,
  };

  const mockQueryBuilder = {
    leftJoinAndSelect: jest.fn().mockReturnThis(),
    where: jest.fn().mockReturnThis(),
    andWhere: jest.fn().mockReturnThis(),
    orderBy: jest.fn().mockReturnThis(),
    skip: jest.fn().mockReturnThis(),
    take: jest.fn().mockReturnThis(),
    getManyAndCount: jest.fn().mockResolvedValue([[mockUser], 1]),
  };

  const mockUserRepository = {
    findOne: jest.fn(),
    createQueryBuilder: jest.fn().mockReturnValue(mockQueryBuilder),
  };

  const mockMasterProfileRepository = {
    findOne: jest.fn(),
  };

  const mockServiceRepository = {
    findOne: jest.fn(),
    createQueryBuilder: jest.fn().mockReturnValue({
      ...mockQueryBuilder,
      getManyAndCount: jest.fn().mockResolvedValue([[mockService], 1]),
    }),
  };

  beforeEach(async () => {
    // Reset mocks and configure to trigger fallback (Meilisearch fails)
    jest.clearAllMocks();
    mockMeiliIndex.search.mockRejectedValue(new Error('Meilisearch unavailable'));

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        SearchService,
        {
          provide: getRepositoryToken(User),
          useValue: mockUserRepository,
        },
        {
          provide: getRepositoryToken(MasterProfile),
          useValue: mockMasterProfileRepository,
        },
        {
          provide: getRepositoryToken(Service),
          useValue: mockServiceRepository,
        },
      ],
    }).compile();

    service = module.get<SearchService>(SearchService);
    userRepository = module.get<Repository<User>>(getRepositoryToken(User));
    masterProfileRepository = module.get<Repository<MasterProfile>>(
      getRepositoryToken(MasterProfile),
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

  describe('searchMasters - Fallback', () => {
    it('should use PostgreSQL fallback when Meilisearch fails', async () => {
      mockMasterProfileRepository.findOne.mockResolvedValue(mockMasterProfile);

      const result = await service.searchMasters({
        query: 'парикмахер',
        page: 1,
        limit: 20,
      });

      expect(result).toBeDefined();
      expect(result.data).toHaveLength(1);
      expect(result.total).toBe(1);
      expect(result.query).toBe('парикмахер');
      expect(mockUserRepository.createQueryBuilder).toHaveBeenCalled();
    });

    it('should filter by category_id in fallback search', async () => {
      mockMasterProfileRepository.findOne.mockResolvedValue(mockMasterProfile);

      await service.searchMasters({
        query: '',
        category_id: 'cat-uuid-1',
        page: 1,
        limit: 20,
      });

      expect(mockQueryBuilder.andWhere).toHaveBeenCalledWith(
        ':categoryId = ANY(profile.category_ids)',
        { categoryId: 'cat-uuid-1' },
      );
    });

    it('should filter by min_rating in fallback search', async () => {
      mockMasterProfileRepository.findOne.mockResolvedValue(mockMasterProfile);

      await service.searchMasters({
        query: '',
        min_rating: 4.0,
        page: 1,
        limit: 20,
      });

      expect(mockQueryBuilder.andWhere).toHaveBeenCalledWith(
        'user.rating >= :minRating',
        { minRating: 4.0 },
      );
    });

    it('should return empty results on fallback error', async () => {
      mockQueryBuilder.getManyAndCount.mockRejectedValueOnce(
        new Error('Database error'),
      );

      const result = await service.searchMasters({
        query: 'test',
        page: 1,
        limit: 20,
      });

      expect(result.data).toHaveLength(0);
      expect(result.total).toBe(0);
    });
  });

  describe('searchServices - Fallback', () => {
    it('should use PostgreSQL fallback when Meilisearch fails', async () => {
      mockMasterProfileRepository.findOne.mockResolvedValue(mockMasterProfile);
      mockUserRepository.findOne.mockResolvedValue(mockUser);

      const result = await service.searchServices({
        query: 'стрижка',
        page: 1,
        limit: 20,
      });

      expect(result).toBeDefined();
      expect(result.data).toHaveLength(1);
      expect(result.total).toBe(1);
      expect(result.query).toBe('стрижка');
      expect(mockServiceRepository.createQueryBuilder).toHaveBeenCalled();
    });

    it('should filter by price range in fallback search', async () => {
      const serviceQb = mockServiceRepository.createQueryBuilder();
      mockMasterProfileRepository.findOne.mockResolvedValue(mockMasterProfile);
      mockUserRepository.findOne.mockResolvedValue(mockUser);

      await service.searchServices({
        query: '',
        min_price: 1000,
        max_price: 2000,
        page: 1,
        limit: 20,
      });

      expect(serviceQb.andWhere).toHaveBeenCalledWith(
        'service.price >= :minPrice',
        { minPrice: 1000 },
      );
      expect(serviceQb.andWhere).toHaveBeenCalledWith(
        'service.price <= :maxPrice',
        { maxPrice: 2000 },
      );
    });

    it('should filter by duration range in fallback search', async () => {
      const serviceQb = mockServiceRepository.createQueryBuilder();
      mockMasterProfileRepository.findOne.mockResolvedValue(mockMasterProfile);
      mockUserRepository.findOne.mockResolvedValue(mockUser);

      await service.searchServices({
        query: '',
        min_duration: 30,
        max_duration: 90,
        page: 1,
        limit: 20,
      });

      expect(serviceQb.andWhere).toHaveBeenCalledWith(
        'service.duration_minutes >= :minDuration',
        { minDuration: 30 },
      );
      expect(serviceQb.andWhere).toHaveBeenCalledWith(
        'service.duration_minutes <= :maxDuration',
        { maxDuration: 90 },
      );
    });

    it('should return empty results on fallback error', async () => {
      const serviceQb = mockServiceRepository.createQueryBuilder();
      serviceQb.getManyAndCount.mockRejectedValueOnce(
        new Error('Database error'),
      );

      const result = await service.searchServices({
        query: 'test',
        page: 1,
        limit: 20,
      });

      expect(result.data).toHaveLength(0);
      expect(result.total).toBe(0);
    });
  });

  describe('calculateDistance', () => {
    it('should calculate distance between two points', () => {
      // Access private method through service instance
      const calculateDistance = (service as any).calculateDistance.bind(service);

      // Moscow to Saint Petersburg (approximately 635 km)
      const distance = calculateDistance(55.7558, 37.6173, 59.9311, 30.3609);

      expect(distance).toBeGreaterThan(600);
      expect(distance).toBeLessThan(700);
    });

    it('should return undefined if coordinates are missing', () => {
      const calculateDistance = (service as any).calculateDistance.bind(service);

      const distance = calculateDistance(null, null, 59.9311, 30.3609);

      expect(distance).toBeUndefined();
    });
  });
});
