import { Test, TestingModule } from '@nestjs/testing';
import { CategoriesService } from './categories.service';
import { getRepositoryToken } from '@nestjs/typeorm';
import { Repository, TreeRepository } from 'typeorm';
import { Category } from './entities/category.entity';
import { CategoryTranslation } from './entities/category-translation.entity';
import {
  NotFoundException,
  ConflictException,
  BadRequestException,
} from '@nestjs/common';

describe('CategoriesService', () => {
  let service: CategoriesService;
  let categoryRepository: TreeRepository<Category>;
  let translationRepository: Repository<CategoryTranslation>;

  const mockCategoryId = 'category-uuid';
  const mockParentId = 'parent-uuid';

  const mockCategory: Partial<Category> = {
    id: mockCategoryId,
    parent_id: null,
    slug: 'test-category',
    level: 0,
    display_order: 0,
    masters_count: 5,
    services_count: 10,
    is_active: true,
    is_popular: false,
  };

  const mockTranslation: Partial<CategoryTranslation> = {
    id: 'translation-uuid',
    category_id: mockCategoryId,
    language: 'ru',
    name: 'Тестовая категория',
    description: 'Описание категории',
    keywords: ['тест', 'категория'],
  };

  const mockCategoryRepository = {
    findOne: jest.fn(),
    find: jest.fn(),
    create: jest.fn(),
    save: jest.fn(),
    remove: jest.fn(),
    count: jest.fn(),
    findTrees: jest.fn(),
    findRoots: jest.fn(),
    findDescendantsTree: jest.fn(),
    findDescendants: jest.fn(),
    findAncestors: jest.fn(),
  };

  const mockTranslationRepository = {
    find: jest.fn(),
    findOne: jest.fn(),
    create: jest.fn(),
    save: jest.fn(),
    delete: jest.fn(),
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        CategoriesService,
        {
          provide: getRepositoryToken(Category),
          useValue: mockCategoryRepository,
        },
        {
          provide: getRepositoryToken(CategoryTranslation),
          useValue: mockTranslationRepository,
        },
      ],
    }).compile();

    service = module.get<CategoriesService>(CategoriesService);
    categoryRepository = module.get<TreeRepository<Category>>(
      getRepositoryToken(Category),
    );
    translationRepository = module.get<Repository<CategoryTranslation>>(
      getRepositoryToken(CategoryTranslation),
    );
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  describe('create', () => {
    const createDto = {
      slug: 'new-category',
      translations: [
        {
          language: 'ru',
          name: 'Новая категория',
          description: 'Описание',
        },
      ],
    };

    it('should create a category successfully', async () => {
      mockCategoryRepository.findOne.mockResolvedValue(null);
      mockCategoryRepository.create.mockReturnValue(mockCategory);
      mockCategoryRepository.save.mockResolvedValue(mockCategory);
      mockTranslationRepository.create.mockReturnValue(mockTranslation);
      mockTranslationRepository.save.mockResolvedValue([mockTranslation]);

      const result = await service.create(createDto as any);

      expect(result).toBeDefined();
      expect(result.slug).toBe(mockCategory.slug);
      expect(mockCategoryRepository.save).toHaveBeenCalled();
      expect(mockTranslationRepository.save).toHaveBeenCalled();
    });

    it('should throw ConflictException if slug already exists', async () => {
      mockCategoryRepository.findOne.mockResolvedValue(mockCategory);

      await expect(service.create(createDto as any)).rejects.toThrow(
        ConflictException,
      );
    });

    it('should throw NotFoundException if parent not found', async () => {
      mockCategoryRepository.findOne
        .mockResolvedValueOnce(null) // slug check
        .mockResolvedValueOnce(null); // parent check

      const dtoWithParent = { ...createDto, parent_id: mockParentId };

      await expect(service.create(dtoWithParent as any)).rejects.toThrow(
        NotFoundException,
      );
    });
  });

  describe('findAll', () => {
    it('should return all categories with translations', async () => {
      mockCategoryRepository.find.mockResolvedValue([mockCategory]);
      mockTranslationRepository.find.mockResolvedValue([mockTranslation]);

      const result = await service.findAll('ru');

      expect(result).toHaveLength(1);
      expect(result[0].id).toBe(mockCategoryId);
      expect(result[0].translations).toHaveLength(1);
      expect(mockCategoryRepository.find).toHaveBeenCalled();
    });
  });

  describe('findOne', () => {
    it('should return category by id', async () => {
      mockCategoryRepository.findOne.mockResolvedValue(mockCategory);
      mockTranslationRepository.find.mockResolvedValue([mockTranslation]);

      const result = await service.findOne(mockCategoryId, 'ru');

      expect(result.id).toBe(mockCategoryId);
      expect(result.translations).toHaveLength(1);
      expect(mockCategoryRepository.findOne).toHaveBeenCalledWith({
        where: { id: mockCategoryId },
      });
    });

    it('should throw NotFoundException if category not found', async () => {
      mockCategoryRepository.findOne.mockResolvedValue(null);

      await expect(service.findOne(mockCategoryId, 'ru')).rejects.toThrow(
        NotFoundException,
      );
    });
  });

  describe('findBySlug', () => {
    it('should return category by slug', async () => {
      mockCategoryRepository.findOne.mockResolvedValue(mockCategory);
      mockTranslationRepository.find.mockResolvedValue([mockTranslation]);

      const result = await service.findBySlug('test-category', 'ru');

      expect(result.slug).toBe('test-category');
      expect(mockCategoryRepository.findOne).toHaveBeenCalledWith({
        where: { slug: 'test-category' },
      });
    });

    it('should throw NotFoundException if slug not found', async () => {
      mockCategoryRepository.findOne.mockResolvedValue(null);

      await expect(service.findBySlug('nonexistent', 'ru')).rejects.toThrow(
        NotFoundException,
      );
    });
  });

  describe('update', () => {
    const updateDto = {
      display_order: 5,
      is_popular: true,
    };

    it('should update category successfully', async () => {
      mockCategoryRepository.findOne.mockResolvedValue(mockCategory);
      mockCategoryRepository.save.mockResolvedValue({
        ...mockCategory,
        ...updateDto,
      });
      mockTranslationRepository.find.mockResolvedValue([mockTranslation]);

      const result = await service.update(mockCategoryId, updateDto as any);

      expect(result.display_order).toBe(5);
      expect(result.is_popular).toBe(true);
      expect(mockCategoryRepository.save).toHaveBeenCalled();
    });

    it('should throw NotFoundException if category not found', async () => {
      mockCategoryRepository.findOne.mockResolvedValue(null);

      await expect(
        service.update(mockCategoryId, updateDto as any),
      ).rejects.toThrow(NotFoundException);
    });

    it('should update translations if provided', async () => {
      mockCategoryRepository.findOne.mockResolvedValue(mockCategory);
      mockCategoryRepository.save.mockResolvedValue(mockCategory);
      mockTranslationRepository.delete.mockResolvedValue({ affected: 1 } as any);
      mockTranslationRepository.create.mockReturnValue(mockTranslation);
      mockTranslationRepository.save.mockResolvedValue([mockTranslation]);
      mockTranslationRepository.find.mockResolvedValue([mockTranslation]);

      const updateWithTranslations = {
        translations: [
          {
            language: 'ru',
            name: 'Обновленное название',
            description: 'Новое описание',
          },
        ],
      };

      await service.update(mockCategoryId, updateWithTranslations as any);

      expect(mockTranslationRepository.delete).toHaveBeenCalledWith({
        category_id: mockCategoryId,
      });
      expect(mockTranslationRepository.save).toHaveBeenCalled();
    });
  });

  describe('remove', () => {
    it('should remove category successfully', async () => {
      const categoryToRemove = {
        ...mockCategory,
        masters_count: 0,
        services_count: 0,
      };

      mockCategoryRepository.findOne.mockResolvedValue(categoryToRemove);
      mockCategoryRepository.count.mockResolvedValue(0);
      mockTranslationRepository.delete.mockResolvedValue({ affected: 1 } as any);
      mockCategoryRepository.remove.mockResolvedValue(categoryToRemove);

      await service.remove(mockCategoryId);

      expect(mockCategoryRepository.remove).toHaveBeenCalledWith(categoryToRemove);
      expect(mockTranslationRepository.delete).toHaveBeenCalledWith({
        category_id: mockCategoryId,
      });
    });

    it('should throw NotFoundException if category not found', async () => {
      mockCategoryRepository.findOne.mockResolvedValue(null);

      await expect(service.remove(mockCategoryId)).rejects.toThrow(
        NotFoundException,
      );
    });

    it('should throw BadRequestException if has children', async () => {
      mockCategoryRepository.findOne.mockResolvedValue(mockCategory);
      mockCategoryRepository.count.mockResolvedValue(2);

      await expect(service.remove(mockCategoryId)).rejects.toThrow(
        BadRequestException,
      );
    });

    it('should throw BadRequestException if has masters or services', async () => {
      mockCategoryRepository.findOne.mockResolvedValue({
        ...mockCategory,
        masters_count: 5,
      });
      mockCategoryRepository.count.mockResolvedValue(0);

      await expect(service.remove(mockCategoryId)).rejects.toThrow(
        BadRequestException,
      );
    });
  });

  describe('move', () => {
    const moveDto = {
      new_parent_id: 'new-parent-uuid',
    };

    it('should move category successfully', async () => {
      const parentCategory = {
        id: 'new-parent-uuid',
        level: 0,
      };

      mockCategoryRepository.findOne
        .mockResolvedValueOnce(mockCategory) // category
        .mockResolvedValueOnce(parentCategory); // new parent

      mockCategoryRepository.findDescendants.mockResolvedValue([mockCategory]);
      mockCategoryRepository.save.mockResolvedValue({
        ...mockCategory,
        parent_id: 'new-parent-uuid',
        level: 1,
      });
      mockTranslationRepository.find.mockResolvedValue([mockTranslation]);

      const result = await service.move(mockCategoryId, moveDto as any);

      expect(result.parent_id).toBe('new-parent-uuid');
      expect(mockCategoryRepository.save).toHaveBeenCalled();
    });

    it('should throw NotFoundException if category not found', async () => {
      mockCategoryRepository.findOne.mockResolvedValue(null);

      await expect(
        service.move(mockCategoryId, moveDto as any),
      ).rejects.toThrow(NotFoundException);
    });

    it('should throw NotFoundException if new parent not found', async () => {
      mockCategoryRepository.findOne
        .mockResolvedValueOnce(mockCategory)
        .mockResolvedValueOnce(null);

      await expect(
        service.move(mockCategoryId, moveDto as any),
      ).rejects.toThrow(NotFoundException);
    });

    it('should throw BadRequestException if moving to descendant', async () => {
      const descendantCategory = {
        id: 'descendant-uuid',
        level: 1,
      };

      mockCategoryRepository.findOne
        .mockResolvedValueOnce(mockCategory)
        .mockResolvedValueOnce(descendantCategory);

      mockCategoryRepository.findDescendants.mockResolvedValue([
        mockCategory,
        { id: 'new-parent-uuid' },
      ]);

      await expect(
        service.move(mockCategoryId, moveDto as any),
      ).rejects.toThrow(BadRequestException);
    });
  });

  describe('getPopular', () => {
    it('should return popular categories', async () => {
      mockCategoryRepository.find.mockResolvedValue([
        { ...mockCategory, is_popular: true },
      ]);
      mockTranslationRepository.findOne.mockResolvedValue(mockTranslation);

      const result = await service.getPopular('ru');

      expect(result).toHaveLength(1);
      expect(mockCategoryRepository.find).toHaveBeenCalledWith({
        where: { is_popular: true, is_active: true },
        order: { display_order: 'ASC' },
      });
    });
  });
});
