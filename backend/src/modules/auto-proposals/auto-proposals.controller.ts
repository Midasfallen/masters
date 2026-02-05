import {
  Controller,
  Get,
  Post,
  Patch,
  Body,
  Param,
  UseGuards,
  Request,
  HttpCode,
  HttpStatus,
} from '@nestjs/common';
import {
  ApiTags,
  ApiOperation,
  ApiResponse,
  ApiBearerAuth,
  ApiOkResponse,
  ApiCreatedResponse,
  ApiBadRequestResponse,
  ApiUnauthorizedResponse,
  ApiNotFoundResponse,
  ApiParam,
  ApiTooManyRequestsResponse,
} from '@nestjs/swagger';
import { AutoProposalsService } from './auto-proposals.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { SettingsResponseDto } from './dto/settings-response.dto';
import { UpdateAutoProposalSettingsDto } from './dto/update-settings.dto';
import { ProposalResponseDto } from './dto/proposal-response.dto';
import { AcceptProposalDto } from './dto/accept-proposal.dto';
import { ProposalStatus } from './entities/auto-proposal.entity';

@ApiTags('Auto Proposals')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller('auto-proposals')
export class AutoProposalsController {
  constructor(
    private readonly autoProposalsService: AutoProposalsService,
  ) {}

  // ============ SETTINGS ============

  @Get('settings')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Получить настройки автопредложений',
    description: 'Возвращает текущие настройки автопредложений пользователя',
  })
  @ApiOkResponse({
    description: 'Настройки автопредложений',
    type: SettingsResponseDto,
    schema: {
      example: {
        userId: '0517ac4e-e4a6-465b-a41f-c86e95d13476',
        enabled: true,
        maxProposalsPerDay: 5,
        preferredCategories: ['550e8400-e29b-41d4-a716-446655440000'],
        minRating: 4.0,
        maxDistanceKm: 10,
        lastGeneratedAt: '2025-01-13T10:00:00Z',
        createdAt: '2025-01-10T10:00:00Z',
        updatedAt: '2025-01-13T10:00:00Z',
      },
    },
  })
  @ApiUnauthorizedResponse({
    description: 'Не авторизован',
    schema: {
      example: {
        statusCode: 401,
        message: 'Unauthorized',
        error: 'Unauthorized',
      },
    },
  })
  async getSettings(@Request() req): Promise<SettingsResponseDto> {
    return this.autoProposalsService.getSettings(req.user.id);
  }

  @Patch('settings')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Обновить настройки автопредложений',
    description: 'Обновляет настройки автопредложений пользователя',
  })
  @ApiOkResponse({
    description: 'Настройки обновлены',
    type: SettingsResponseDto,
    schema: {
      example: {
        userId: '0517ac4e-e4a6-465b-a41f-c86e95d13476',
        enabled: true,
        maxProposalsPerDay: 10,
        preferredCategories: ['550e8400-e29b-41d4-a716-446655440000', '660e8400-e29b-41d4-a716-446655440001'],
        minRating: 4.5,
        maxDistanceKm: 15,
        lastGeneratedAt: '2025-01-13T10:00:00Z',
        createdAt: '2025-01-10T10:00:00Z',
        updatedAt: '2025-01-13T11:00:00Z',
      },
    },
  })
  @ApiBadRequestResponse({
    description: 'Некорректные данные',
    schema: {
      example: {
        statusCode: 400,
        message: [
          'maxProposalsPerDay must be between 1 and 50',
          'minRating must be between 0 and 5',
        ],
        error: 'Bad Request',
      },
    },
  })
  @ApiUnauthorizedResponse({
    description: 'Не авторизован',
    schema: {
      example: {
        statusCode: 401,
        message: 'Unauthorized',
        error: 'Unauthorized',
      },
    },
  })
  async updateSettings(
    @Request() req,
    @Body() updateDto: UpdateAutoProposalSettingsDto,
  ): Promise<SettingsResponseDto> {
    return this.autoProposalsService.updateSettings(req.user.id, updateDto);
  }

  // ============ PROPOSALS ============

  @Get()
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Получить все предложения пользователя',
    description: 'Возвращает все предложения пользователя (всех статусов)',
  })
  @ApiOkResponse({
    description: 'Список предложений',
    type: [ProposalResponseDto],
    schema: {
      example: [
        {
          id: '550e8400-e29b-41d4-a716-446655440000',
          userId: '0517ac4e-e4a6-465b-a41f-c86e95d13476',
          masterId: 'bebd027c-e57a-4adc-bdd5-9cd4b1e544fe',
          serviceId: '550e8400-e29b-41d4-a716-446655440001',
          proposedTime: '2025-01-20T14:00:00Z',
          status: 'pending',
          reason: 'Подходит под ваши предпочтения',
          createdAt: '2025-01-13T10:00:00Z',
          updatedAt: '2025-01-13T10:00:00Z',
        },
      ],
    },
  })
  @ApiUnauthorizedResponse({
    description: 'Не авторизован',
    schema: {
      example: {
        statusCode: 401,
        message: 'Unauthorized',
        error: 'Unauthorized',
      },
    },
  })
  async getUserProposals(@Request() req): Promise<ProposalResponseDto[]> {
    return this.autoProposalsService.getUserProposals(req.user.id);
  }

  @Get('active')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Получить активные (PENDING) предложения',
    description: 'Возвращает только активные предложения со статусом PENDING',
  })
  @ApiOkResponse({
    description: 'Список активных предложений',
    type: [ProposalResponseDto],
    schema: {
      example: [
        {
          id: '550e8400-e29b-41d4-a716-446655440000',
          userId: '0517ac4e-e4a6-465b-a41f-c86e95d13476',
          masterId: 'bebd027c-e57a-4adc-bdd5-9cd4b1e544fe',
          serviceId: '550e8400-e29b-41d4-a716-446655440001',
          proposedTime: '2025-01-20T14:00:00Z',
          status: 'pending',
          reason: 'Подходит под ваши предпочтения',
          createdAt: '2025-01-13T10:00:00Z',
          updatedAt: '2025-01-13T10:00:00Z',
        },
      ],
    },
  })
  @ApiUnauthorizedResponse({
    description: 'Не авторизован',
    schema: {
      example: {
        statusCode: 401,
        message: 'Unauthorized',
        error: 'Unauthorized',
      },
    },
  })
  async getActiveProposals(@Request() req): Promise<ProposalResponseDto[]> {
    return this.autoProposalsService.getUserProposals(
      req.user.id,
      ProposalStatus.PENDING,
    );
  }

  @Get(':id')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Получить одно предложение по ID',
    description: 'Возвращает детальную информацию о предложении',
  })
  @ApiParam({
    name: 'id',
    description: 'UUID предложения',
    example: '550e8400-e29b-41d4-a716-446655440000',
  })
  @ApiOkResponse({
    description: 'Данные предложения',
    type: ProposalResponseDto,
    schema: {
      example: {
        id: '550e8400-e29b-41d4-a716-446655440000',
        userId: '0517ac4e-e4a6-465b-a41f-c86e95d13476',
        masterId: 'bebd027c-e57a-4adc-bdd5-9cd4b1e544fe',
        serviceId: '550e8400-e29b-41d4-a716-446655440001',
        proposedTime: '2025-01-20T14:00:00Z',
        status: 'pending',
        reason: 'Подходит под ваши предпочтения',
        createdAt: '2025-01-13T10:00:00Z',
        updatedAt: '2025-01-13T10:00:00Z',
      },
    },
  })
  @ApiBadRequestResponse({
    description: 'Некорректный UUID',
    schema: {
      example: {
        statusCode: 400,
        message: 'Validation failed (uuid is expected)',
        error: 'Bad Request',
      },
    },
  })
  @ApiUnauthorizedResponse({
    description: 'Не авторизован',
    schema: {
      example: {
        statusCode: 401,
        message: 'Unauthorized',
        error: 'Unauthorized',
      },
    },
  })
  @ApiNotFoundResponse({
    description: 'Предложение не найдено',
    schema: {
      example: {
        statusCode: 404,
        message: 'Proposal not found',
        error: 'Not Found',
      },
    },
  })
  async getProposal(
    @Request() req,
    @Param('id') proposalId: string,
  ): Promise<ProposalResponseDto> {
    return this.autoProposalsService.getProposal(req.user.id, proposalId);
  }

  @Post(':id/accept')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Принять предложение (создать бронирование)',
    description: 'Принимает предложение и создает бронирование на основе предложения',
  })
  @ApiParam({
    name: 'id',
    description: 'UUID предложения',
    example: '550e8400-e29b-41d4-a716-446655440000',
  })
  @ApiOkResponse({
    description: 'Предложение принято, бронирование создано',
    schema: {
      example: {
        proposal: {
          id: '550e8400-e29b-41d4-a716-446655440000',
          userId: '0517ac4e-e4a6-465b-a41f-c86e95d13476',
          masterId: 'bebd027c-e57a-4adc-bdd5-9cd4b1e544fe',
          serviceId: '550e8400-e29b-41d4-a716-446655440001',
          proposedTime: '2025-01-20T14:00:00Z',
          status: 'accepted',
          reason: 'Подходит под ваши предпочтения',
          createdAt: '2025-01-13T10:00:00Z',
          updatedAt: '2025-01-13T11:00:00Z',
        },
        bookingId: '550e8400-e29b-41d4-a716-446655440002',
      },
    },
  })
  @ApiBadRequestResponse({
    description: 'Некорректные данные или предложение уже обработано',
    schema: {
      examples: {
        invalidData: {
          value: {
            statusCode: 400,
            message: ['comment must be a string'],
            error: 'Bad Request',
          },
        },
        alreadyProcessed: {
          value: {
            statusCode: 400,
            message: 'Proposal already processed',
            error: 'Bad Request',
          },
        },
      },
    },
  })
  @ApiUnauthorizedResponse({
    description: 'Не авторизован',
    schema: {
      example: {
        statusCode: 401,
        message: 'Unauthorized',
        error: 'Unauthorized',
      },
    },
  })
  @ApiNotFoundResponse({
    description: 'Предложение не найдено',
    schema: {
      example: {
        statusCode: 404,
        message: 'Proposal not found',
        error: 'Not Found',
      },
    },
  })
  async acceptProposal(
    @Request() req,
    @Param('id') proposalId: string,
    @Body() acceptDto: AcceptProposalDto,
  ): Promise<{ proposal: ProposalResponseDto; bookingId: string }> {
    return this.autoProposalsService.acceptProposal(
      req.user.id,
      proposalId,
      acceptDto,
    );
  }

  @Post(':id/reject')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Отклонить предложение',
    description: 'Отклоняет предложение. Статус меняется на rejected.',
  })
  @ApiParam({
    name: 'id',
    description: 'UUID предложения',
    example: '550e8400-e29b-41d4-a716-446655440000',
  })
  @ApiOkResponse({
    description: 'Предложение отклонено',
    type: ProposalResponseDto,
    schema: {
      example: {
        id: '550e8400-e29b-41d4-a716-446655440000',
        userId: '0517ac4e-e4a6-465b-a41f-c86e95d13476',
        masterId: 'bebd027c-e57a-4adc-bdd5-9cd4b1e544fe',
        serviceId: '550e8400-e29b-41d4-a716-446655440001',
        proposedTime: '2025-01-20T14:00:00Z',
        status: 'rejected',
        reason: 'Подходит под ваши предпочтения',
        createdAt: '2025-01-13T10:00:00Z',
        updatedAt: '2025-01-13T11:00:00Z',
      },
    },
  })
  @ApiBadRequestResponse({
    description: 'Некорректный UUID или предложение уже обработано',
    schema: {
      example: {
        statusCode: 400,
        message: 'Proposal already processed',
        error: 'Bad Request',
      },
    },
  })
  @ApiUnauthorizedResponse({
    description: 'Не авторизован',
    schema: {
      example: {
        statusCode: 401,
        message: 'Unauthorized',
        error: 'Unauthorized',
      },
    },
  })
  @ApiNotFoundResponse({
    description: 'Предложение не найдено',
    schema: {
      example: {
        statusCode: 404,
        message: 'Proposal not found',
        error: 'Not Found',
      },
    },
  })
  async rejectProposal(
    @Request() req,
    @Param('id') proposalId: string,
  ): Promise<ProposalResponseDto> {
    return this.autoProposalsService.rejectProposal(req.user.id, proposalId);
  }

  // ============ MANUAL GENERATION ============

  @Post('generate')
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({
    summary: 'Запросить генерацию предложений вручную',
    description:
      'Создает новые предложения на основе настроек пользователя. Можно вызывать не чаще чем раз в 24 часа.',
  })
  @ApiCreatedResponse({
    description: 'Предложения успешно сгенерированы',
    type: [ProposalResponseDto],
    schema: {
      example: [
        {
          id: '550e8400-e29b-41d4-a716-446655440000',
          userId: '0517ac4e-e4a6-465b-a41f-c86e95d13476',
          masterId: 'bebd027c-e57a-4adc-bdd5-9cd4b1e544fe',
          serviceId: '550e8400-e29b-41d4-a716-446655440001',
          proposedTime: '2025-01-20T14:00:00Z',
          status: 'pending',
          reason: 'Подходит под ваши предпочтения',
          createdAt: '2025-01-13T10:00:00Z',
          updatedAt: '2025-01-13T10:00:00Z',
        },
      ],
    },
  })
  @ApiBadRequestResponse({
    description: 'Настройки не настроены',
    schema: {
      example: {
        statusCode: 400,
        message: 'Auto proposals settings not configured',
        error: 'Bad Request',
      },
    },
  })
  @ApiUnauthorizedResponse({
    description: 'Не авторизован',
    schema: {
      example: {
        statusCode: 401,
        message: 'Unauthorized',
        error: 'Unauthorized',
      },
    },
  })
  @ApiTooManyRequestsResponse({
    description: 'Слишком частый запрос (менее 24 часов с последней генерации)',
    schema: {
      example: {
        statusCode: 429,
        message: 'Too many requests. Please wait 24 hours before generating again',
        error: 'Too Many Requests',
      },
    },
  })
  async generateProposals(@Request() req): Promise<ProposalResponseDto[]> {
    return this.autoProposalsService.generateProposalForUser(req.user.id);
  }
}
