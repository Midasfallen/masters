import {
  Injectable,
  NotFoundException,
  BadRequestException,
  ConflictException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, TreeRepository, In } from 'typeorm';
import { Category } from './entities/category.entity';
import { CategoryTranslation } from './entities/category-translation.entity';
import { CreateCategoryDto } from './dto/create-category.dto';
import { UpdateCategoryDto } from './dto/update-category.dto';
import { MoveCategoryDto } from './dto/move-category.dto';
import {
  CategoryResponseDto,
  CategoryTreeResponseDto,
} from './dto/category-response.dto';

@Injectable()
export class CategoriesService {
  constructor(
    @InjectRepository(Category)
    private readonly categoryRepository: TreeRepository<Category>,
    @InjectRepository(CategoryTranslation)
    private readonly translationRepository: Repository<CategoryTranslation>,
  ) {}

  /**
   * Создание категории с переводами
   */
  async create(createDto: CreateCategoryDto): Promise<CategoryResponseDto> {
    // Проверяем уникальность slug
    const existingCategory = await this.categoryRepository.findOne({
      where: { slug: createDto.slug },
    });

    if (existingCategory) {
      throw new ConflictException(
        `Категория с slug "${createDto.slug}" уже существует`,
      );
    }

    // Проверяем родительскую категорию
    let parent: Category | null = null;
    let level = 0;

    if (createDto.parent_id) {
      parent = await this.categoryRepository.findOne({
        where: { id: createDto.parent_id },
      });

      if (!parent) {
        throw new NotFoundException('Родительская категория не найдена');
      }

      level = parent.level + 1;
    }

    // Создаем категорию
    const category = this.categoryRepository.create({
      parent_id: createDto.parent_id || null,
      slug: createDto.slug,
      level,
      icon_url: createDto.icon_url,
      image_url: createDto.image_url,
      color: createDto.color,
      display_order: createDto.display_order ?? 0,
      is_active: createDto.is_active ?? true,
      is_popular: createDto.is_popular ?? false,
      metadata: createDto.metadata,
    });

    if (parent) {
      category.parent = parent;
    }

    const savedCategory = await this.categoryRepository.save(category);

    // Создаем переводы
    const translations = createDto.translations.map((translationDto) =>
      this.translationRepository.create({
        category_id: savedCategory.id,
        language: translationDto.language,
        name: translationDto.name,
        description: translationDto.description,
        keywords: translationDto.keywords || [],
      }),
    );

    await this.translationRepository.save(translations);

    return this.mapToResponseDto(savedCategory, translations);
  }

  /**
   * Получение всех категорий плоским списком
   */
  async findAll(language: string = 'ru'): Promise<CategoryResponseDto[]> {
    const categories = await this.categoryRepository.find({
      order: { display_order: 'ASC', level: 'ASC' },
    });

    const translations = await this.translationRepository.find({
      where: { category_id: In(categories.map((c) => c.id)), language },
    });

    return categories.map((category) => {
      const categoryTranslations = translations.filter(
        (t) => t.category_id === category.id,
      );
      return this.mapToResponseDto(category, categoryTranslations);
    });
  }

  /**
   * Получение дерева категорий
   */
  async getTree(language: string = 'ru'): Promise<CategoryTreeResponseDto[]> {
    const trees = await this.categoryRepository.findTrees();

    return Promise.all(
      trees.map((tree) => this.mapTreeToResponseDto(tree, language)),
    );
  }

  /**
   * Получение корневых категорий
   */
  async getRoots(language: string = 'ru'): Promise<CategoryTreeResponseDto[]> {
    const roots = await this.categoryRepository.findRoots();

    return Promise.all(
      roots.map((root) => this.mapTreeToResponseDto(root, language, false)),
    );
  }

  /**
   * Получение категории по ID
   */
  async findOne(
    id: string,
    language: string = 'ru',
  ): Promise<CategoryResponseDto> {
    const category = await this.categoryRepository.findOne({
      where: { id },
    });

    if (!category) {
      throw new NotFoundException('Категория не найдена');
    }

    const translations = await this.translationRepository.find({
      where: { category_id: id },
    });

    return this.mapToResponseDto(category, translations);
  }

  /**
   * Получение категории по slug
   */
  async findBySlug(
    slug: string,
    language: string = 'ru',
  ): Promise<CategoryResponseDto> {
    const category = await this.categoryRepository.findOne({
      where: { slug },
    });

    if (!category) {
      throw new NotFoundException('Категория не найдена');
    }

    const translations = await this.translationRepository.find({
      where: { category_id: category.id },
    });

    return this.mapToResponseDto(category, translations);
  }

  /**
   * Получение дочерних категорий
   */
  async getChildren(
    id: string,
    language: string = 'ru',
  ): Promise<CategoryTreeResponseDto[]> {
    const category = await this.categoryRepository.findOne({
      where: { id },
    });

    if (!category) {
      throw new NotFoundException('Категория не найдена');
    }

    const children = await this.categoryRepository.findDescendantsTree(
      category,
    );

    if (!children.children || children.children.length === 0) {
      return [];
    }

    return Promise.all(
      children.children.map((child) =>
        this.mapTreeToResponseDto(child, language),
      ),
    );
  }

  /**
   * Получение родителей категории (путь от корня)
   */
  async getAncestors(
    id: string,
    language: string = 'ru',
  ): Promise<CategoryTreeResponseDto[]> {
    const category = await this.categoryRepository.findOne({
      where: { id },
    });

    if (!category) {
      throw new NotFoundException('Категория не найдена');
    }

    const ancestors = await this.categoryRepository.findAncestors(category);

    return Promise.all(
      ancestors.map((ancestor) =>
        this.mapTreeToResponseDto(ancestor, language, false),
      ),
    );
  }

  /**
   * Обновление категории
   */
  async update(
    id: string,
    updateDto: UpdateCategoryDto,
  ): Promise<CategoryResponseDto> {
    const category = await this.categoryRepository.findOne({
      where: { id },
    });

    if (!category) {
      throw new NotFoundException('Категория не найдена');
    }

    // Обновляем основные поля
    Object.assign(category, {
      icon_url: updateDto.icon_url ?? category.icon_url,
      image_url: updateDto.image_url ?? category.image_url,
      color: updateDto.color ?? category.color,
      display_order: updateDto.display_order ?? category.display_order,
      is_active: updateDto.is_active ?? category.is_active,
      is_popular: updateDto.is_popular ?? category.is_popular,
      metadata: updateDto.metadata ?? category.metadata,
    });

    const updatedCategory = await this.categoryRepository.save(category);

    // Обновляем переводы если предоставлены
    if (updateDto.translations && updateDto.translations.length > 0) {
      // Удаляем старые переводы
      await this.translationRepository.delete({ category_id: id });

      // Создаем новые
      const newTranslations = updateDto.translations.map((translationDto) =>
        this.translationRepository.create({
          category_id: id,
          language: translationDto.language,
          name: translationDto.name,
          description: translationDto.description,
          keywords: translationDto.keywords || [],
        }),
      );

      await this.translationRepository.save(newTranslations);
    }

    const translations = await this.translationRepository.find({
      where: { category_id: id },
    });

    return this.mapToResponseDto(updatedCategory, translations);
  }

  /**
   * Перемещение категории (изменение родителя)
   */
  async move(id: string, moveDto: MoveCategoryDto): Promise<CategoryResponseDto> {
    const category = await this.categoryRepository.findOne({
      where: { id },
    });

    if (!category) {
      throw new NotFoundException('Категория не найдена');
    }

    // Проверяем новую родительскую категорию
    let newParent: Category | null = null;
    let newLevel = 0;

    if (moveDto.new_parent_id) {
      newParent = await this.categoryRepository.findOne({
        where: { id: moveDto.new_parent_id },
      });

      if (!newParent) {
        throw new NotFoundException('Новая родительская категория не найдена');
      }

      // Проверяем, что не перемещаем категорию в её потомков
      const descendants = await this.categoryRepository.findDescendants(
        category,
      );
      const descendantIds = descendants.map((d) => d.id);

      if (descendantIds.includes(moveDto.new_parent_id)) {
        throw new BadRequestException(
          'Нельзя переместить категорию в её потомков',
        );
      }

      newLevel = newParent.level + 1;
    }

    // Обновляем parent_id и level
    category.parent_id = moveDto.new_parent_id || null;
    category.level = newLevel;

    if (newParent) {
      category.parent = newParent;
    }

    const updatedCategory = await this.categoryRepository.save(category);

    // Обновляем уровни всех потомков
    await this.updateDescendantsLevel(category);

    const translations = await this.translationRepository.find({
      where: { category_id: id },
    });

    return this.mapToResponseDto(updatedCategory, translations);
  }

  /**
   * Удаление категории
   */
  async remove(id: string): Promise<void> {
    const category = await this.categoryRepository.findOne({
      where: { id },
    });

    if (!category) {
      throw new NotFoundException('Категория не найдена');
    }

    // Проверяем, есть ли дочерние категории
    const children = await this.categoryRepository.count({
      where: { parent_id: id },
    });

    if (children > 0) {
      throw new BadRequestException(
        'Нельзя удалить категорию с дочерними элементами',
      );
    }

    // Проверяем, есть ли связанные мастера или услуги
    if (category.masters_count > 0 || category.services_count > 0) {
      throw new BadRequestException(
        'Нельзя удалить категорию, в которой есть мастера или услуги',
      );
    }

    // Удаляем переводы
    await this.translationRepository.delete({ category_id: id });

    // Удаляем категорию
    await this.categoryRepository.remove(category);
  }

  /**
   * Получение популярных категорий
   */
  async getPopular(
    language: string = 'ru',
  ): Promise<CategoryTreeResponseDto[]> {
    const categories = await this.categoryRepository.find({
      where: { is_popular: true, is_active: true },
      order: { display_order: 'ASC' },
    });

    return Promise.all(
      categories.map((category) =>
        this.mapTreeToResponseDto(category, language, false),
      ),
    );
  }

  /**
   * Обновление счетчиков (вызывается при создании/удалении мастеров/услуг)
   */
  async updateCounters(categoryId: string): Promise<void> {
    // TODO: Реализовать подсчет мастеров и услуг
    // Будет вызываться из Masters и Services модулей
  }

  /**
   * Рекурсивное обновление уровней потомков
   */
  private async updateDescendantsLevel(category: Category): Promise<void> {
    const descendants = await this.categoryRepository.findDescendants(category);

    for (const descendant of descendants) {
      if (descendant.id === category.id) continue;

      const parent = await this.categoryRepository.findOne({
        where: { id: descendant.parent_id },
      });

      if (parent) {
        descendant.level = parent.level + 1;
        await this.categoryRepository.save(descendant);
      }
    }
  }

  /**
   * Маппинг entity в DTO
   */
  private mapToResponseDto(
    category: Category,
    translations: CategoryTranslation[],
  ): CategoryResponseDto {
    return {
      id: category.id,
      parent_id: category.parent_id,
      slug: category.slug,
      level: category.level,
      icon_url: category.icon_url,
      image_url: category.image_url,
      color: category.color,
      display_order: category.display_order,
      masters_count: category.masters_count,
      services_count: category.services_count,
      is_active: category.is_active,
      is_popular: category.is_popular,
      metadata: category.metadata,
      created_at: category.created_at,
      updated_at: category.updated_at,
      translations: translations.map((t) => ({
        id: t.id,
        language: t.language,
        name: t.name,
        description: t.description,
        keywords: t.keywords,
      })),
    };
  }

  /**
   * Рекурсивный маппинг дерева в DTO
   * ВАЖНО: Level 1 категории больше не содержат children (level 2 удалены)
   */
  private async mapTreeToResponseDto(
    category: Category,
    language: string,
    includeChildren: boolean = true,
  ): Promise<CategoryTreeResponseDto> {
    const translation = await this.translationRepository.findOne({
      where: { category_id: category.id, language },
    });

    const result: CategoryTreeResponseDto = {
      id: category.id,
      slug: category.slug,
      level: category.level,
      icon_url: category.icon_url,
      color: category.color,
      display_order: category.display_order,
      masters_count: category.masters_count,
      is_popular: category.is_popular,
      name: translation?.name || category.slug,
      description: translation?.description,
    };

    // Включаем children только для level 0 категорий
    // Level 1 категории больше не содержат level 2 (они теперь в service_templates)
    if (
      includeChildren &&
      category.level === 0 &&
      category.children &&
      category.children.length > 0
    ) {
      // Фильтруем только level 1 children (убираем level 2, если они есть)
      const level1Children = category.children.filter((child) => child.level === 1);
      
      if (level1Children.length > 0) {
        result.children = await Promise.all(
          level1Children.map((child) =>
            this.mapTreeToResponseDto(child, language, false), // false - не включаем children для level 1
          ),
        );
      }
    }

    return result;
  }
}
