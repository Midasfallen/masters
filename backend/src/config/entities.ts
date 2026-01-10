// Explicit entity imports for TypeORM
// This avoids glob pattern issues with webpack bundling

import { User } from '../modules/users/entities/user.entity';
import { MasterProfile } from '../modules/masters/entities/master-profile.entity';
import { Category } from '../modules/categories/entities/category.entity';
import { CategoryTranslation } from '../modules/categories/entities/category-translation.entity';
import { Service } from '../modules/services/entities/service.entity';
import { Booking } from '../modules/bookings/entities/booking.entity';
import { Review } from '../modules/reviews/entities/review.entity';
import { Chat } from '../modules/chats/entities/chat.entity';
import { ChatParticipant } from '../modules/chats/entities/chat-participant.entity';
import { Message } from '../modules/chats/entities/message.entity';
import { Friendship } from '../modules/friends/entities/friendship.entity';
import { Subscription } from '../modules/friends/entities/subscription.entity';
import { Notification } from '../modules/notifications/entities/notification.entity';
import { DeviceToken } from '../modules/notifications/entities/device-token.entity';
import { Post } from '../modules/posts/entities/post.entity';
import { PostMedia } from '../modules/posts/entities/post-media.entity';
import { Like } from '../modules/social/entities/like.entity';
import { Comment } from '../modules/social/entities/comment.entity';
import { Repost } from '../modules/social/entities/repost.entity';
import { AutoProposal } from '../modules/auto-proposals/entities/auto-proposal.entity';
import { AutoProposalSettings } from '../modules/auto-proposals/entities/auto-proposal-settings.entity';

export const entities = [
  User,
  MasterProfile,
  Category,
  CategoryTranslation,
  Service,
  Booking,
  Review,
  Chat,
  ChatParticipant,
  Message,
  Friendship,
  Subscription,
  Notification,
  DeviceToken,
  Post,
  PostMedia,
  Like,
  Comment,
  Repost,
  AutoProposal,
  AutoProposalSettings,
];
