import { Test, TestingModule } from '@nestjs/testing';
import { MastersService } from './masters.service';
import { getRepositoryToken } from '@nestjs/typeorm';
import { MasterProfile } from './entities/master-profile.entity';
import { User } from '../users/entities/user.entity';
import { Repository } from 'typeorm';
import {
  NotFoundException,
  BadRequestException,
  ForbiddenException,
} from '@nestjs/common';

describe('MastersService', () => {
  let service: MastersService;
  let masterProfileRepository: Repository<MasterProfile>;
  let userRepository: Repository<User>;

  const mockUser = {
    id: 'user-1',
    email: 'master@example.com',
    first_name: 'John',
    last_name: 'Doe',
    is_master: false,
    master_profile_completed: false,
  };

  const mockMasterProfile = {
    id: 'profile-1',
    user_id: 'user-1',
    setup_step: 0,
    is_active: false,
    is_approved: false,
    category_ids: [],
    subcategory_ids: [],
  };

  const mockMasterProfileRepository = {
    findOne: jest.fn(),
    create: jest.fn(),
    save: jest.fn(),
    remove: jest.fn(),
  };

  const mockUserRepository = {
    findOne: jest.fn(),
    save: jest.fn(),
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        MastersService,
        {
          provide: getRepositoryToken(MasterProfile),
          useValue: mockMasterProfileRepository,
        },
        {
          provide: getRepositoryToken(User),
          useValue: mockUserRepository,
        },
      ],
    }).compile();

    service = module.get<MastersService>(MastersService);
    masterProfileRepository = module.get<Repository<MasterProfile>>(
      getRepositoryToken(MasterProfile),
    );
    userRepository = module.get<Repository<User>>(getRepositoryToken(User));
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  describe('initializeProfile', () => {
    it('should create new master profile', async () => {
      mockMasterProfileRepository.findOne.mockResolvedValue(null);
      mockMasterProfileRepository.create.mockReturnValue(mockMasterProfile);
      mockMasterProfileRepository.save.mockResolvedValue(mockMasterProfile);

      const result = await service.initializeProfile('user-1');

      expect(result).toEqual(mockMasterProfile);
      expect(mockMasterProfileRepository.create).toHaveBeenCalledWith({
        user_id: 'user-1',
        setup_step: 0,
        is_active: false,
        is_approved: false,
      });
      expect(mockMasterProfileRepository.save).toHaveBeenCalled();
    });

    it('should throw BadRequestException if profile already exists', async () => {
      mockMasterProfileRepository.findOne.mockResolvedValue(mockMasterProfile);

      await expect(service.initializeProfile('user-1')).rejects.toThrow(
        BadRequestException,
      );
    });
  });

  describe('updateStep1', () => {
    it('should update step 1 with categories', async () => {
      const step1Dto = {
        category_ids: ['cat-1', 'cat-2'],
        subcategory_ids: ['subcat-1'],
      };

      const profile = { ...mockMasterProfile, setup_step: 0 };
      mockMasterProfileRepository.findOne.mockResolvedValue(profile);
      mockMasterProfileRepository.save.mockResolvedValue({
        ...profile,
        ...step1Dto,
        setup_step: 1,
      });

      const result = await service.updateStep1('user-1', step1Dto);

      expect(result.setupStep).toBe(1);
      expect(result.categoryIds).toEqual(step1Dto.category_ids);
      expect(mockMasterProfileRepository.save).toHaveBeenCalled();
    });

    it('should throw BadRequestException if step 1 already completed', async () => {
      const profile = { ...mockMasterProfile, setup_step: 2 };
      mockMasterProfileRepository.findOne.mockResolvedValue(profile);

      await expect(
        service.updateStep1('user-1', { category_ids: [] }),
      ).rejects.toThrow(BadRequestException);
    });

    it('should throw NotFoundException if profile not found', async () => {
      mockMasterProfileRepository.findOne.mockResolvedValue(null);

      await expect(
        service.updateStep1('user-1', { category_ids: [] }),
      ).rejects.toThrow(NotFoundException);
    });
  });

  describe('updateStep2', () => {
    it('should update step 2 with profile info', async () => {
      const step2Dto = {
        business_name: 'Beauty Studio',
        bio: 'Professional makeup artist',
        years_of_experience: 5,
        languages: ['en', 'ru'],
        is_mobile: true,
        has_location: false,
        is_online_only: false,
      };

      const profile = { ...mockMasterProfile, setup_step: 1 };
      mockMasterProfileRepository.findOne.mockResolvedValue(profile);
      mockMasterProfileRepository.save.mockResolvedValue({
        ...profile,
        ...step2Dto,
        setup_step: 2,
      });

      const result = await service.updateStep2('user-1', step2Dto);

      expect(result.setupStep).toBe(2);
      expect(result.businessName).toBe(step2Dto.business_name);
      expect(mockMasterProfileRepository.save).toHaveBeenCalled();
    });

    it('should throw BadRequestException if step 1 not completed', async () => {
      const profile = { ...mockMasterProfile, setup_step: 0 };
      mockMasterProfileRepository.findOne.mockResolvedValue(profile);

      await expect(service.updateStep2('user-1', { bio: '' })).rejects.toThrow(
        BadRequestException,
      );
    });
  });

  describe('updateStep3', () => {
    it('should update step 3 with portfolio', async () => {
      const step3Dto = {
        portfolio_urls: ['https://example.com/photo1.jpg'],
        video_urls: ['https://youtube.com/video1'],
        certificates: ['Certificate of Excellence'],
      };

      const profile = { ...mockMasterProfile, setup_step: 2 };
      mockMasterProfileRepository.findOne.mockResolvedValue(profile);
      mockMasterProfileRepository.save.mockResolvedValue({
        ...profile,
        ...step3Dto,
        setup_step: 3,
      });

      const result = await service.updateStep3('user-1', step3Dto);

      expect(result.setupStep).toBe(3);
      expect(result.portfolioUrls).toEqual(step3Dto.portfolio_urls);
      expect(mockMasterProfileRepository.save).toHaveBeenCalled();
    });

    it('should throw BadRequestException if step 2 not completed', async () => {
      const profile = { ...mockMasterProfile, setup_step: 1 };
      mockMasterProfileRepository.findOne.mockResolvedValue(profile);

      await expect(service.updateStep3('user-1', {})).rejects.toThrow(
        BadRequestException,
      );
    });
  });

  describe('updateStep4', () => {
    it('should update step 4 with location', async () => {
      const step4Dto = {
        location_lat: 55.7558,
        location_lng: 37.6173,
        location_address: 'Moscow, Russia',
        location_name: 'My Studio',
        service_radius_km: 10,
        is_mobile: true,
        has_location: true,
      };

      const profile = { ...mockMasterProfile, setup_step: 3 };
      mockMasterProfileRepository.findOne.mockResolvedValue(profile);
      mockMasterProfileRepository.save.mockResolvedValue({
        ...profile,
        ...step4Dto,
        setup_step: 4,
      });

      const result = await service.updateStep4('user-1', step4Dto);

      expect(result.setupStep).toBe(4);
      expect(result.locationAddress).toBe(step4Dto.location_address);
      expect(mockMasterProfileRepository.save).toHaveBeenCalled();
    });

    it('should throw BadRequestException if step 3 not completed', async () => {
      const profile = { ...mockMasterProfile, setup_step: 2 };
      mockMasterProfileRepository.findOne.mockResolvedValue(profile);

      await expect(service.updateStep4('user-1', {})).rejects.toThrow(
        BadRequestException,
      );
    });
  });

  describe('updateStep5', () => {
    it('should finalize master profile and update user status', async () => {
      const step5Dto = {
        working_hours: { monday: { start: '09:00', end: '18:00' } },
        min_booking_hours: 24,
        max_bookings_per_day: 5,
        auto_confirm: false,
        social_links: { instagram: '@master' },
      };

      const profile = { ...mockMasterProfile, setup_step: 4 };
      mockMasterProfileRepository.findOne.mockResolvedValue(profile);
      mockMasterProfileRepository.save.mockResolvedValue({
        ...profile,
        ...step5Dto,
        setup_step: 5,
        is_active: true,
      });
      mockUserRepository.findOne.mockResolvedValue(mockUser);
      mockUserRepository.save.mockResolvedValue({
        ...mockUser,
        is_master: true,
        master_profile_completed: true,
      });

      const result = await service.updateStep5('user-1', step5Dto);

      expect(result.setupStep).toBe(5);
      expect(result.isActive).toBe(true);
      expect(mockUserRepository.save).toHaveBeenCalledWith(
        expect.objectContaining({
          is_master: true,
          master_profile_completed: true,
        }),
      );
    });

    it('should throw BadRequestException if step 4 not completed', async () => {
      const profile = { ...mockMasterProfile, setup_step: 3 };
      mockMasterProfileRepository.findOne.mockResolvedValue(profile);

      await expect(service.updateStep5('user-1', {})).rejects.toThrow(
        BadRequestException,
      );
    });
  });

  describe('getMyProfile', () => {
    it('should return master profile for user', async () => {
      mockMasterProfileRepository.findOne.mockResolvedValue(mockMasterProfile);

      const result = await service.getMyProfile('user-1');

      expect(result).toEqual(mockMasterProfile);
      expect(mockMasterProfileRepository.findOne).toHaveBeenCalledWith({
        where: { user_id: 'user-1' },
      });
    });

    it('should throw NotFoundException if profile not found', async () => {
      mockMasterProfileRepository.findOne.mockResolvedValue(null);

      await expect(service.getMyProfile('user-1')).rejects.toThrow(
        NotFoundException,
      );
    });
  });

  describe('getProfileById', () => {
    it('should return master profile by id', async () => {
      mockMasterProfileRepository.findOne.mockResolvedValue(mockMasterProfile);

      const result = await service.getProfileById('profile-1');

      expect(result).toEqual(mockMasterProfile);
      expect(mockMasterProfileRepository.findOne).toHaveBeenCalledWith({
        where: { id: 'profile-1' },
      });
    });

    it('should throw NotFoundException if profile not found', async () => {
      mockMasterProfileRepository.findOne.mockResolvedValue(null);

      await expect(service.getProfileById('non-existent')).rejects.toThrow(
        NotFoundException,
      );
    });
  });

  describe('updateProfile', () => {
    it('should update completed master profile', async () => {
      const updateData = {
        bio: 'Updated bio',
        years_of_experience: 10,
      };

      const completedProfile = { ...mockMasterProfile, setup_step: 5 };
      mockMasterProfileRepository.findOne.mockResolvedValue(completedProfile);
      mockMasterProfileRepository.save.mockResolvedValue({
        ...completedProfile,
        ...updateData,
      });

      const result = await service.updateProfile('user-1', updateData);

      expect(result.bio).toBe(updateData.bio);
      expect(mockMasterProfileRepository.save).toHaveBeenCalled();
    });

    it('should throw ForbiddenException if setup not completed', async () => {
      const profile = { ...mockMasterProfile, setup_step: 3 };
      mockMasterProfileRepository.findOne.mockResolvedValue(profile);

      await expect(service.updateProfile('user-1', {})).rejects.toThrow(
        ForbiddenException,
      );
    });

    it('should not allow updating critical fields', async () => {
      const updateData = {
        user_id: 'malicious-user',
        setup_step: 0,
        id: 'malicious-id',
        bio: 'Legitimate update',
      };

      const completedProfile = { ...mockMasterProfile, setup_step: 5 };
      mockMasterProfileRepository.findOne.mockResolvedValue(completedProfile);
      mockMasterProfileRepository.save.mockImplementation((profile) =>
        Promise.resolve(profile),
      );

      await service.updateProfile('user-1', updateData);

      expect(mockMasterProfileRepository.save).toHaveBeenCalledWith(
        expect.not.objectContaining({
          user_id: 'malicious-user',
          setup_step: 0,
          id: 'malicious-id',
        }),
      );
    });
  });

  describe('deleteProfile', () => {
    it('should delete master profile and update user status', async () => {
      mockMasterProfileRepository.findOne.mockResolvedValue(mockMasterProfile);
      mockMasterProfileRepository.remove.mockResolvedValue(mockMasterProfile);
      mockUserRepository.findOne.mockResolvedValue({
        ...mockUser,
        is_master: true,
        master_profile_completed: true,
      });
      mockUserRepository.save.mockResolvedValue({
        ...mockUser,
        is_master: false,
        master_profile_completed: false,
      });

      await service.deleteProfile('user-1');

      expect(mockMasterProfileRepository.remove).toHaveBeenCalledWith(
        mockMasterProfile,
      );
      expect(mockUserRepository.save).toHaveBeenCalledWith(
        expect.objectContaining({
          is_master: false,
          master_profile_completed: false,
        }),
      );
    });
  });
});
