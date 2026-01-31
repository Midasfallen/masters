import {
  Controller,
  Get,
  Post,
  Patch,
  Body,
  Param,
  ParseIntPipe,
  HttpCode,
  HttpStatus,
} from '@nestjs/common';
import {
  ApiTags,
  ApiOperation,
  ApiResponse,
  ApiBearerAuth,
  ApiParam,
} from '@nestjs/swagger';
import { MastersService } from './masters.service';
import { CurrentUser } from '../../common/decorators/current-user.decorator';
import { User } from '../users/entities/user.entity';
import { Step1CategoriesDto } from './dto/step1-categories.dto';
import { Step2ProfileInfoDto } from './dto/step2-profile-info.dto';
import { Step3PortfolioDto } from './dto/step3-portfolio.dto';
import { Step4LocationDto } from './dto/step4-location.dto';
import { Step5ScheduleDto } from './dto/step5-schedule.dto';
import { MasterProfileResponseDto } from './dto/master-profile-response.dto';

@ApiTags('masters')
@ApiBearerAuth()
@Controller('masters')
export class MastersController {
  constructor(private readonly mastersService: MastersService) {}

  @Post()
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({
    summary: 'Начать создание профиля мастера',
    description:
      'Инициализирует пустой профиль мастера (setup_step = 0). После этого нужно пройти все 5 шагов.',
  })
  @ApiResponse({
    status: 201,
    description: 'Профиль мастера создан',
    type: MasterProfileResponseDto,
  })
  @ApiResponse({
    status: 400,
    description: 'Профиль мастера уже создан',
  })
  async initializeProfile(@CurrentUser() user: User): Promise<MasterProfileResponseDto> {
    return this.mastersService.initializeProfile(user.id);
  }

  @Patch('me/step/1')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'ШАГ 1: Выбор категорий услуг',
    description: 'Мастер выбирает категории и подкатегории, в которых он работает',
  })
  @ApiResponse({
    status: 200,
    description: 'Шаг 1 завершен',
    type: MasterProfileResponseDto,
  })
  @ApiResponse({
    status: 400,
    description: 'Некорректные данные или шаг уже завершен',
  })
  async updateStep1(
    @CurrentUser() user: User,
    @Body() step1Dto: Step1CategoriesDto,
  ): Promise<MasterProfileResponseDto> {
    return this.mastersService.updateStep1(user.id, step1Dto);
  }

  @Patch('me/step/2')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'ШАГ 2: Базовая информация профиля',
    description:
      'Название бизнеса, описание, опыт работы, языки, типы обслуживания',
  })
  @ApiResponse({
    status: 200,
    description: 'Шаг 2 завершен',
    type: MasterProfileResponseDto,
  })
  @ApiResponse({
    status: 400,
    description: 'Сначала завершите шаг 1',
  })
  async updateStep2(
    @CurrentUser() user: User,
    @Body() step2Dto: Step2ProfileInfoDto,
  ): Promise<MasterProfileResponseDto> {
    return this.mastersService.updateStep2(user.id, step2Dto);
  }

  @Patch('me/step/3')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'ШАГ 3: Портфолио',
    description:
      'Загрузка фотографий работ (макс 20), видео (макс 5), сертификатов',
  })
  @ApiResponse({
    status: 200,
    description: 'Шаг 3 завершен',
    type: MasterProfileResponseDto,
  })
  @ApiResponse({
    status: 400,
    description: 'Сначала завершите шаг 2',
  })
  async updateStep3(
    @CurrentUser() user: User,
    @Body() step3Dto: Step3PortfolioDto,
  ): Promise<MasterProfileResponseDto> {
    return this.mastersService.updateStep3(user.id, step3Dto);
  }

  @Patch('me/step/4')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'ШАГ 4: География работы',
    description: 'Локация салона, адрес, радиус обслуживания для выездов',
  })
  @ApiResponse({
    status: 200,
    description: 'Шаг 4 завершен',
    type: MasterProfileResponseDto,
  })
  @ApiResponse({
    status: 400,
    description: 'Сначала завершите шаг 3',
  })
  async updateStep4(
    @CurrentUser() user: User,
    @Body() step4Dto: Step4LocationDto,
  ): Promise<MasterProfileResponseDto> {
    return this.mastersService.updateStep4(user.id, step4Dto);
  }

  @Patch('me/step/5')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'ШАГ 5: Расписание и финализация (ФИНАЛЬНЫЙ ШАГ)',
    description:
      'График работы, настройки записей. После завершения: is_master=true, профиль активирован.',
  })
  @ApiResponse({
    status: 200,
    description:
      'Профиль мастера создан! Пользователь теперь мастер (is_master=true)',
    type: MasterProfileResponseDto,
  })
  @ApiResponse({
    status: 400,
    description: 'Сначала завершите шаг 4',
  })
  async updateStep5(
    @CurrentUser() user: User,
    @Body() step5Dto: Step5ScheduleDto,
  ): Promise<MasterProfileResponseDto> {
    return this.mastersService.updateStep5(user.id, step5Dto);
  }

  @Get('me')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Получить свой профиль мастера',
    description: 'Возвращает профиль мастера текущего пользователя',
  })
  @ApiResponse({
    status: 200,
    description: 'Профиль мастера',
    type: MasterProfileResponseDto,
  })
  @ApiResponse({
    status: 404,
    description: 'Профиль мастера не найден',
  })
  async getMyProfile(@CurrentUser() user: User): Promise<MasterProfileResponseDto> {
    return this.mastersService.getMyProfile(user.id);
  }

  @Get(':id')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Получить профиль мастера по ID',
    description:
      'Публичный просмотр профиля мастера. Принимает как ID профиля мастера, так и ID пользователя (user_id). Сначала ищет по ID профиля, если не находит - ищет по user_id.',
  })
  @ApiParam({
    name: 'id',
    description:
      'UUID профиля мастера или UUID пользователя (user_id). Система автоматически определит тип ID.',
    example: '550e8400-e29b-41d4-a716-446655440000',
  })
  @ApiResponse({
    status: 200,
    description: 'Профиль мастера',
    type: MasterProfileResponseDto,
  })
  @ApiResponse({
    status: 404,
    description: 'Профиль не найден',
  })
  async getProfileById(@Param('id') id: string): Promise<MasterProfileResponseDto> {
    return this.mastersService.getProfileById(id);
  }
}
