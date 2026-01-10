import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AutoProposalsController } from './auto-proposals.controller';
import { AutoProposalsService } from './auto-proposals.service';
import { AutoProposal } from './entities/auto-proposal.entity';
import { AutoProposalSettings } from './entities/auto-proposal-settings.entity';
import { User } from '../users/entities/user.entity';
import { MasterProfile } from '../masters/entities/master-profile.entity';
import { Service } from '../services/entities/service.entity';
import { Booking } from '../bookings/entities/booking.entity';
import { NotificationsModule } from '../notifications/notifications.module';

@Module({
  imports: [
    TypeOrmModule.forFeature([
      AutoProposal,
      AutoProposalSettings,
      User,
      MasterProfile,
      Service,
      Booking,
    ]),
    NotificationsModule,
  ],
  controllers: [AutoProposalsController],
  providers: [AutoProposalsService],
  exports: [AutoProposalsService],
})
export class AutoProposalsModule {}
