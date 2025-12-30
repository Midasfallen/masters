import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { FriendshipsController } from './friendships.controller';
import { FriendshipsService } from './friendships.service';
import { SubscriptionsController } from './subscriptions.controller';
import { SubscriptionsService } from './subscriptions.service';
import { Friendship } from './entities/friendship.entity';
import { Subscription } from './entities/subscription.entity';
import { User } from '../users/entities/user.entity';

@Module({
  imports: [TypeOrmModule.forFeature([Friendship, Subscription, User])],
  controllers: [FriendshipsController, SubscriptionsController],
  providers: [FriendshipsService, SubscriptionsService],
  exports: [FriendshipsService, SubscriptionsService],
})
export class FriendsModule {}
