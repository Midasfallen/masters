import {
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Param,
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
import { BookingsService } from './bookings.service';
import { CreateBookingDto } from './dto/create-booking.dto';
import { CancelBookingDto } from './dto/cancel-booking.dto';
import { BookingResponseDto } from './dto/booking-response.dto';
import { FilterBookingsDto } from './dto/filter-bookings.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { PendingReviewsGuard } from '../../common/guards/pending-reviews.guard';

@ApiTags('Bookings')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller('bookings')
export class BookingsController {
  constructor(private readonly bookingsService: BookingsService) {}

  @Post()
  @UseGuards(PendingReviewsGuard)
  @ApiOperation({ summary: 'Создать новое бронирование' })
  @ApiResponse({
    status: 201,
    description: 'Бронирование создано',
    type: BookingResponseDto,
  })
  @ApiResponse({ status: 400, description: 'Невалидные данные' })
  @ApiResponse({ status: 403, description: 'Необходимо оставить отзыв о предыдущей записи' })
  @ApiResponse({ status: 404, description: 'Услуга не найдена' })
  async create(
    @Request() req,
    @Body() createBookingDto: CreateBookingDto,
  ): Promise<BookingResponseDto> {
    return this.bookingsService.create(req.user.id, createBookingDto);
  }

  @Get()
  @ApiOperation({ summary: 'Получить список бронирований с фильтрами' })
  @ApiResponse({
    status: 200,
    description: 'Список бронирований',
    type: [BookingResponseDto],
  })
  async findAll(
    @Request() req,
    @Query() filterDto: FilterBookingsDto,
  ): Promise<{ data: BookingResponseDto[]; total: number; page: number; limit: number }> {
    return this.bookingsService.findAll(req.user.id, filterDto);
  }

  @Get('needs-review')
  @ApiOperation({
    summary: 'Получить бронирования, требующие отзыва',
    description:
      'Возвращает завершенные бронирования, по которым клиент еще не оставил отзыв',
  })
  @ApiResponse({
    status: 200,
    description: 'Список бронирований для отзыва',
    type: [BookingResponseDto],
  })
  async getBookingsNeedingReview(
    @Request() req,
  ): Promise<BookingResponseDto[]> {
    return this.bookingsService.getBookingsNeedingReview(req.user.id);
  }

  @Get('my')
  @ApiOperation({
    summary: 'Получить мои бронирования',
    description: 'Получить бронирования пользователя в роли клиента или мастера',
  })
  @ApiResponse({
    status: 200,
    description: 'Список бронирований',
    type: [BookingResponseDto],
  })
  async getMyBookings(
    @Request() req,
    @Query('role') role: 'client' | 'master',
    @Query() filterDto: FilterBookingsDto,
  ): Promise<{ data: BookingResponseDto[]; total: number; page: number; limit: number }> {
    if (role === 'client') {
      return this.bookingsService.findAll(req.user.id, { ...filterDto, client_id: req.user.id });
    } else if (role === 'master') {
      return this.bookingsService.findAll(req.user.id, { ...filterDto, master_id: req.user.id });
    }
    // Default to client role
    return this.bookingsService.findAll(req.user.id, { ...filterDto, client_id: req.user.id });
  }

  @Get(':id')
  @ApiOperation({ summary: 'Получить бронирование по ID' })
  @ApiParam({ name: 'id', description: 'ID бронирования' })
  @ApiResponse({
    status: 200,
    description: 'Данные бронирования',
    type: BookingResponseDto,
  })
  @ApiResponse({ status: 403, description: 'Нет доступа' })
  @ApiResponse({ status: 404, description: 'Бронирование не найдено' })
  async findOne(
    @Request() req,
    @Param('id') id: string,
  ): Promise<BookingResponseDto> {
    return this.bookingsService.findOne(req.user.id, id);
  }

  @Post(':id/confirm')
  @ApiOperation({
    summary: 'Подтвердить бронирование (мастер)',
    description: 'Мастер подтверждает запрос на бронирование от клиента',
  })
  @ApiParam({ name: 'id', description: 'ID бронирования' })
  @ApiResponse({
    status: 200,
    description: 'Бронирование подтверждено',
    type: BookingResponseDto,
  })
  @ApiResponse({
    status: 400,
    description: 'Невозможно подтвердить (неверный статус)',
  })
  @ApiResponse({ status: 403, description: 'Только мастер может подтвердить' })
  @ApiResponse({ status: 404, description: 'Бронирование не найдено' })
  async confirm(
    @Request() req,
    @Param('id') id: string,
  ): Promise<BookingResponseDto> {
    return this.bookingsService.confirmBooking(req.user.id, id);
  }

  @Patch(':id/reject')
  @ApiOperation({
    summary: 'Отклонить бронирование (мастер)',
    description: 'Мастер отклоняет запрос на бронирование с указанием причины',
  })
  @ApiParam({ name: 'id', description: 'ID бронирования' })
  @ApiResponse({
    status: 200,
    description: 'Бронирование отклонено',
    type: BookingResponseDto,
  })
  @ApiResponse({
    status: 400,
    description: 'Невозможно отклонить (неверный статус)',
  })
  @ApiResponse({ status: 403, description: 'Только мастер может отклонить' })
  @ApiResponse({ status: 404, description: 'Бронирование не найдено' })
  async reject(
    @Request() req,
    @Param('id') id: string,
    @Body() body: { reason: string },
  ): Promise<BookingResponseDto> {
    return this.bookingsService.rejectBooking(req.user.id, id, body.reason);
  }

  @Post(':id/cancel')
  @ApiOperation({
    summary: 'Отменить бронирование',
    description:
      'Клиент или мастер может отменить бронирование с указанием причины. Клиент не может отменить менее чем за 1 час до начала.',
  })
  @ApiParam({ name: 'id', description: 'ID бронирования' })
  @ApiResponse({
    status: 200,
    description: 'Бронирование отменено',
    type: BookingResponseDto,
  })
  @ApiResponse({
    status: 400,
    description: 'Невозможно отменить (неверный статус или слишком поздно)',
  })
  @ApiResponse({
    status: 403,
    description: 'Нет прав для отмены этого бронирования',
  })
  @ApiResponse({ status: 404, description: 'Бронирование не найдено' })
  async cancel(
    @Request() req,
    @Param('id') id: string,
    @Body() cancelDto: CancelBookingDto,
  ): Promise<BookingResponseDto> {
    return this.bookingsService.cancelBooking(req.user.id, id, cancelDto);
  }

  @Patch(':id/start')
  @ApiOperation({
    summary: 'Начать работу (мастер)',
    description:
      'Мастер отмечает, что клиент пришел и работа началась (меняет статус на IN_PROGRESS)',
  })
  @ApiParam({ name: 'id', description: 'ID бронирования' })
  @ApiResponse({
    status: 200,
    description: 'Работа началась',
    type: BookingResponseDto,
  })
  @ApiResponse({
    status: 400,
    description: 'Невозможно начать (неверный статус)',
  })
  @ApiResponse({ status: 403, description: 'Только мастер может начать работу' })
  @ApiResponse({ status: 404, description: 'Бронирование не найдено' })
  async start(
    @Request() req,
    @Param('id') id: string,
  ): Promise<BookingResponseDto> {
    return this.bookingsService.startBooking(req.user.id, id);
  }

  @Post(':id/complete')
  @ApiOperation({
    summary: 'Завершить работу (мастер)',
    description:
      'Мастер завершает работу по бронированию. После этого клиент может оставить отзыв.',
  })
  @ApiParam({ name: 'id', description: 'ID бронирования' })
  @ApiResponse({
    status: 200,
    description: 'Работа завершена',
    type: BookingResponseDto,
  })
  @ApiResponse({
    status: 400,
    description: 'Невозможно завершить (неверный статус)',
  })
  @ApiResponse({
    status: 403,
    description: 'Только мастер может завершить работу',
  })
  @ApiResponse({ status: 404, description: 'Бронирование не найдено' })
  async complete(
    @Request() req,
    @Param('id') id: string,
  ): Promise<BookingResponseDto> {
    return this.bookingsService.completeBooking(req.user.id, id);
  }
}
