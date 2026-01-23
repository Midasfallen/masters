import {
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Param,
  Delete,
  Query,
  UseGuards,
  Request,
} from '@nestjs/common';
import {
  ApiTags,
  ApiBearerAuth,
  ApiOperation,
  ApiResponse,
  ApiParam,
} from '@nestjs/swagger';
import { ReviewsService } from './reviews.service';
import { CreateReviewDto } from './dto/create-review.dto';
import { ResponseReviewDto } from './dto/response-review.dto';
import { ReviewResponseDto, ReviewStatsDto } from './dto/review-response.dto';
import { FilterReviewsDto } from './dto/filter-reviews.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { Public } from '../auth/decorators/public.decorator';

@ApiTags('Reviews')
@Controller('reviews')
export class ReviewsController {
  constructor(private readonly reviewsService: ReviewsService) {}

  @Post()
  @ApiBearerAuth()
  @UseGuards(JwtAuthGuard)
  @ApiOperation({
    summary: 'Создать отзыв',
    description:
      'Создание отзыва после завершения бронирования. Клиент оставляет отзыв мастеру, мастер - клиенту.',
  })
  @ApiResponse({
    status: 201,
    description: 'Отзыв создан',
    type: ReviewResponseDto,
  })
  @ApiResponse({ status: 400, description: 'Бронирование не завершено или невалидные данные' })
  @ApiResponse({ status: 404, description: 'Бронирование не найдено' })
  @ApiResponse({ status: 409, description: 'Отзыв уже оставлен' })
  async create(
    @Request() req,
    @Body() createReviewDto: CreateReviewDto,
  ): Promise<ReviewResponseDto> {
    return this.reviewsService.create(req.user.sub, createReviewDto);
  }

  @Patch(':id/respond')
  @ApiBearerAuth()
  @UseGuards(JwtAuthGuard)
  @ApiOperation({
    summary: 'Ответить на отзыв',
    description:
      'Пользователь, которому оставлен отзыв, может оставить ответ на него',
  })
  @ApiParam({ name: 'id', description: 'ID отзыва' })
  @ApiResponse({
    status: 200,
    description: 'Ответ добавлен',
    type: ReviewResponseDto,
  })
  @ApiResponse({ status: 403, description: 'Можно отвечать только на отзывы о себе' })
  @ApiResponse({ status: 404, description: 'Отзыв не найден' })
  @ApiResponse({ status: 409, description: 'Ответ уже оставлен' })
  async respond(
    @Request() req,
    @Param('id') id: string,
    @Body() responseDto: ResponseReviewDto,
  ): Promise<ReviewResponseDto> {
    return this.reviewsService.respondToReview(req.user.sub, id, responseDto);
  }

  @Post(':id/report')
  @ApiBearerAuth()
  @UseGuards(JwtAuthGuard)
  @ApiOperation({
    summary: 'Пожаловаться на отзыв',
    description:
      'Отправка жалобы на отзыв. При 5+ жалобах отзыв автоматически скрывается',
  })
  @ApiParam({ name: 'id', description: 'ID отзыва' })
  @ApiResponse({ status: 200, description: 'Жалоба принята' })
  @ApiResponse({ status: 404, description: 'Отзыв не найден' })
  async report(@Param('id') id: string): Promise<void> {
    return this.reviewsService.reportReview(id);
  }

  @Public()
  @Get('user/:userId/stats')
  @ApiOperation({
    summary: 'Получить статистику отзывов пользователя',
    description:
      'Возвращает общую статистику: средний рейтинг, распределение оценок, количество отзывов',
  })
  @ApiParam({ name: 'userId', description: 'ID пользователя' })
  @ApiResponse({
    status: 200,
    description: 'Статистика отзывов',
    type: ReviewStatsDto,
  })
  async getUserStats(@Param('userId') userId: string): Promise<ReviewStatsDto> {
    return this.reviewsService.getUserStats(userId);
  }

  @Public()
  @Get()
  @ApiOperation({
    summary: 'Получить список отзывов с фильтрами',
    description:
      'Публичный endpoint для получения отзывов с фильтрацией по пользователю, рейтингу и т.д.',
  })
  @ApiResponse({
    status: 200,
    description: 'Список отзывов',
    type: [ReviewResponseDto],
  })
  async findAll(
    @Query() filterDto: FilterReviewsDto,
  ): Promise<{ data: ReviewResponseDto[]; total: number; page: number; limit: number }> {
    return this.reviewsService.findAll(filterDto);
  }

  @Public()
  @Get(':id')
  @ApiOperation({
    summary: 'Получить отзыв по ID',
    description: 'Публичный просмотр отдельного отзыва',
  })
  @ApiParam({ name: 'id', description: 'ID отзыва' })
  @ApiResponse({
    status: 200,
    description: 'Данные отзыва',
    type: ReviewResponseDto,
  })
  @ApiResponse({ status: 404, description: 'Отзыв не найден' })
  async findOne(@Param('id') id: string): Promise<ReviewResponseDto> {
    return this.reviewsService.findOne(id);
  }

  @Delete(':id')
  @ApiBearerAuth()
  @UseGuards(JwtAuthGuard)
  @ApiOperation({
    summary: 'Удалить свой отзыв',
    description:
      'Пользователь может удалить только свой отзыв (soft delete - скрытие)',
  })
  @ApiParam({ name: 'id', description: 'ID отзыва' })
  @ApiResponse({ status: 200, description: 'Отзыв удален' })
  @ApiResponse({ status: 403, description: 'Можно удалять только свои отзывы' })
  @ApiResponse({ status: 404, description: 'Отзыв не найден' })
  async remove(@Request() req, @Param('id') id: string): Promise<void> {
    return this.reviewsService.remove(req.user.sub, id);
  }

  @Get('unreviewed/bookings')
  @ApiBearerAuth()
  @UseGuards(JwtAuthGuard)
  @ApiOperation({
    summary: 'Получить неотзывленные бронирования',
    description:
      'Возвращает список завершенных бронирований, на которые пользователь еще не оставил отзыв',
  })
  @ApiResponse({
    status: 200,
    description: 'Список неотзывленных бронирований',
  })
  async getUnreviewedBookings(@Request() req) {
    return this.reviewsService.getUnreviewedBookings(req.user.sub);
  }

  @Post('skip/:bookingId')
  @ApiBearerAuth()
  @UseGuards(JwtAuthGuard)
  @ApiOperation({
    summary: 'Пропустить отзыв',
    description:
      'Обрабатывает пропуск напоминания об отзыве. Поддерживает grace period skip (один раз без последствий)',
  })
  @ApiParam({ name: 'bookingId', description: 'ID бронирования' })
  @ApiResponse({
    status: 200,
    description: 'Пропуск обработан',
  })
  @ApiResponse({ status: 400, description: 'Grace period уже использован или отзыв уже оставлен' })
  @ApiResponse({ status: 404, description: 'Бронирование не найдено' })
  async skipReview(
    @Request() req,
    @Param('bookingId') bookingId: string,
    @Body() body: { isGracePeriod: boolean },
  ) {
    return this.reviewsService.handleSkipReview(
      req.user.sub,
      bookingId,
      body.isGracePeriod || false,
    );
  }
}
