import {
  Controller,
  Get,
  Post,
  Patch,
  Body,
  Param,
  UseGuards,
  Request,
} from '@nestjs/common';
import {
  ApiTags,
  ApiOperation,
  ApiResponse,
  ApiBearerAuth,
} from '@nestjs/swagger';
import { AutoProposalsService } from './auto-proposals.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { AutoProposalSettings } from './entities/auto-proposal-settings.entity';
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
  @ApiOperation({ summary: 'Получить настройки автопредложений' })
  @ApiResponse({ status: 200, type: AutoProposalSettings })
  async getSettings(@Request() req): Promise<AutoProposalSettings> {
    return this.autoProposalsService.getSettings(req.user.id);
  }

  @Patch('settings')
  @ApiOperation({ summary: 'Обновить настройки автопредложений' })
  @ApiResponse({ status: 200, type: AutoProposalSettings })
  async updateSettings(
    @Request() req,
    @Body() updateDto: UpdateAutoProposalSettingsDto,
  ): Promise<AutoProposalSettings> {
    return this.autoProposalsService.updateSettings(req.user.id, updateDto);
  }

  // ============ PROPOSALS ============

  @Get()
  @ApiOperation({ summary: 'Получить все предложения пользователя' })
  @ApiResponse({ status: 200, type: [ProposalResponseDto] })
  async getUserProposals(@Request() req): Promise<ProposalResponseDto[]> {
    return this.autoProposalsService.getUserProposals(req.user.id);
  }

  @Get('active')
  @ApiOperation({ summary: 'Получить активные (PENDING) предложения' })
  @ApiResponse({ status: 200, type: [ProposalResponseDto] })
  async getActiveProposals(@Request() req): Promise<ProposalResponseDto[]> {
    return this.autoProposalsService.getUserProposals(
      req.user.id,
      ProposalStatus.PENDING,
    );
  }

  @Get(':id')
  @ApiOperation({ summary: 'Получить одно предложение по ID' })
  @ApiResponse({ status: 200, type: ProposalResponseDto })
  async getProposal(
    @Request() req,
    @Param('id') proposalId: string,
  ): Promise<ProposalResponseDto> {
    return this.autoProposalsService.getProposal(req.user.id, proposalId);
  }

  @Post(':id/accept')
  @ApiOperation({ summary: 'Принять предложение (создать бронирование)' })
  @ApiResponse({
    status: 200,
    schema: {
      properties: {
        proposal: { type: 'object' },
        booking_id: { type: 'string' },
      },
    },
  })
  async acceptProposal(
    @Request() req,
    @Param('id') proposalId: string,
    @Body() acceptDto: AcceptProposalDto,
  ): Promise<{ proposal: ProposalResponseDto; booking_id: string }> {
    return this.autoProposalsService.acceptProposal(
      req.user.id,
      proposalId,
      acceptDto,
    );
  }

  @Post(':id/reject')
  @ApiOperation({ summary: 'Отклонить предложение' })
  @ApiResponse({ status: 200, type: ProposalResponseDto })
  async rejectProposal(
    @Request() req,
    @Param('id') proposalId: string,
  ): Promise<ProposalResponseDto> {
    return this.autoProposalsService.rejectProposal(req.user.id, proposalId);
  }

  // ============ MANUAL GENERATION ============

  @Post('generate')
  @ApiOperation({
    summary: 'Запросить генерацию предложений вручную',
    description:
      'Создает новые предложения на основе настроек пользователя. Можно вызывать не чаще чем раз в 24 часа.',
  })
  @ApiResponse({ status: 201, type: [ProposalResponseDto] })
  async generateProposals(@Request() req): Promise<ProposalResponseDto[]> {
    return this.autoProposalsService.generateProposalForUser(req.user.id);
  }
}
