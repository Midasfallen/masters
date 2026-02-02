import {
  Controller,
  Get,
  Post,
  Patch,
  Delete,
  Body,
  Param,
  Query,
  HttpCode,
  HttpStatus,
} from '@nestjs/common';
import {
  ApiTags,
  ApiOperation,
  ApiResponse,
  ApiBearerAuth,
  ApiParam,
  ApiQuery,
} from '@nestjs/swagger';
import { Public } from '../auth/decorators/public.decorator';
import { ServicesService } from './services.service';
import { CurrentUser } from '../../common/decorators/current-user.decorator';
import { User } from '../users/entities/user.entity';
import { CreateServiceDto } from './dto/create-service.dto';
import { UpdateServiceDto } from './dto/update-service.dto';
import { FilterServicesDto } from './dto/filter-services.dto';
import { ServiceResponseDto } from './dto/service-response.dto';
import { PaginatedResponseDto } from '../../common/dto/pagination.dto';

@ApiTags('services')
@ApiBearerAuth()
@Controller('services')
export class ServicesController {
  constructor(private readonly servicesService: ServicesService) {}

  @Post()
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({
    summary: 'Создать новую услугу',
    description:
      'Только для мастеров с завершенным профилем. Категория услуги должна быть в профиле мастера.',
  })
  @ApiResponse({
    status: 201,
    description: 'Услуга создана',
    type: ServiceResponseDto,
  })
  @ApiResponse({
    status: 403,
    description: 'Только мастера могут создавать услуги',
  })
  @ApiResponse({
    status: 400,
    description: 'Некорректные данные или категория не в профиле мастера',
  })
  async create(
    @CurrentUser() user: User,
    @Body() createServiceDto: CreateServiceDto,
  ): Promise<ServiceResponseDto> {
    return this.servicesService.create(user.id, createServiceDto);
  }

  @Public()
  @Get()
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Получить услуги по категориям',
    description: 'Публичный endpoint для получения услуг, отфильтрованных по категориям',
  })
  @ApiQuery({
    name: 'category_ids',
    required: false,
    type: [String],
    description: 'Список UUID категорий для фильтрации',
    example: ['uuid-1', 'uuid-2'],
  })
  @ApiResponse({
    status: 200,
    description: 'Список услуг',
    type: ServiceResponseDto,
    isArray: true,
  })
  async findByCategories(
    @Query('category_ids') categoryIds?: string[],
  ): Promise<ServiceResponseDto[]> {
    // Преобразуем строку или массив строк в массив
    const ids = Array.isArray(categoryIds)
      ? categoryIds
      : categoryIds
        ? [categoryIds]
        : undefined;
    return this.servicesService.findByCategoryIds(ids);
  }

  @Get('my')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Получить мои услуги',
    description: 'Список всех услуг текущего мастера с фильтрацией и пагинацией',
  })
  @ApiResponse({
    status: 200,
    description: 'Список услуг мастера',
    type: ServiceResponseDto,
    isArray: true,
  })
  @ApiResponse({
    status: 404,
    description: 'Профиль мастера не найден',
  })
  async getMyServices(
    @CurrentUser() user: User,
    @Query() filterDto: FilterServicesDto,
  ): Promise<PaginatedResponseDto<ServiceResponseDto>> {
    return this.servicesService.getMyServices(user.id, filterDto);
  }

  @Get('master/:masterId')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Получить услуги мастера',
    description: 'Публичный просмотр услуг конкретного мастера',
  })
  @ApiParam({
    name: 'masterId',
    description: 'UUID профиля мастера',
    example: '550e8400-e29b-41d4-a716-446655440000',
  })
  @ApiResponse({
    status: 200,
    description: 'Список услуг мастера',
    type: ServiceResponseDto,
    isArray: true,
  })
  async getServicesByMaster(
    @Param('masterId') masterId: string,
    @Query() filterDto: FilterServicesDto,
  ): Promise<PaginatedResponseDto<ServiceResponseDto>> {
    return this.servicesService.getServicesByMaster(masterId, filterDto);
  }

  @Get(':id')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Получить услугу по ID',
    description: 'Детальная информация об услуге',
  })
  @ApiParam({
    name: 'id',
    description: 'UUID услуги',
    example: '550e8400-e29b-41d4-a716-446655440000',
  })
  @ApiResponse({
    status: 200,
    description: 'Информация об услуге',
    type: ServiceResponseDto,
  })
  @ApiResponse({
    status: 404,
    description: 'Услуга не найдена',
  })
  async findById(@Param('id') id: string): Promise<ServiceResponseDto> {
    return this.servicesService.findById(id);
  }

  @Patch(':id')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Обновить услугу',
    description: 'Только владелец может обновлять свои услуги',
  })
  @ApiParam({
    name: 'id',
    description: 'UUID услуги',
  })
  @ApiResponse({
    status: 200,
    description: 'Услуга обновлена',
    type: ServiceResponseDto,
  })
  @ApiResponse({
    status: 403,
    description: 'Можно редактировать только свои услуги',
  })
  @ApiResponse({
    status: 404,
    description: 'Услуга не найдена',
  })
  async update(
    @CurrentUser() user: User,
    @Param('id') id: string,
    @Body() updateServiceDto: UpdateServiceDto,
  ): Promise<ServiceResponseDto> {
    return this.servicesService.update(user.id, id, updateServiceDto);
  }

  @Patch(':id/deactivate')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Деактивировать услугу',
    description: 'Мягкое удаление - услуга становится неактивной (is_active=false)',
  })
  @ApiParam({
    name: 'id',
    description: 'UUID услуги',
  })
  @ApiResponse({
    status: 200,
    description: 'Услуга деактивирована',
    type: ServiceResponseDto,
  })
  @ApiResponse({
    status: 403,
    description: 'Можно деактивировать только свои услуги',
  })
  async deactivate(@CurrentUser() user: User, @Param('id') id: string): Promise<ServiceResponseDto> {
    return this.servicesService.deactivate(user.id, id);
  }

  @Patch(':id/activate')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Активировать услугу',
    description: 'Активирует ранее деактивированную услугу (is_active=true)',
  })
  @ApiParam({
    name: 'id',
    description: 'UUID услуги',
  })
  @ApiResponse({
    status: 200,
    description: 'Услуга активирована',
    type: ServiceResponseDto,
  })
  @ApiResponse({
    status: 403,
    description: 'Можно активировать только свои услуги',
  })
  async activate(@CurrentUser() user: User, @Param('id') id: string): Promise<ServiceResponseDto> {
    return this.servicesService.activate(user.id, id);
  }

  @Delete(':id')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiOperation({
    summary: 'Удалить услугу',
    description: 'Полное удаление услуги. Только владелец может удалять свои услуги.',
  })
  @ApiParam({
    name: 'id',
    description: 'UUID услуги',
  })
  @ApiResponse({
    status: 204,
    description: 'Услуга удалена',
  })
  @ApiResponse({
    status: 403,
    description: 'Можно удалять только свои услуги',
  })
  @ApiResponse({
    status: 404,
    description: 'Услуга не найдена',
  })
  async remove(@CurrentUser() user: User, @Param('id') id: string): Promise<void> {
    return this.servicesService.remove(user.id, id);
  }
}
