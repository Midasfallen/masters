import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { PostsController } from './posts.controller';
import { PostsService } from './posts.service';
import { Post } from './entities/post.entity';
import { PostMedia } from './entities/post-media.entity';
import { PostService } from './entities/post-service.entity';
import { Service } from '../services/entities/service.entity';
import { Friendship } from '../friends/entities/friendship.entity';
import { Subscription } from '../friends/entities/subscription.entity';
import { SocialModule } from '../social/social.module';
import { CommonModule } from '../../common/common.module';

@Module({
  imports: [
    TypeOrmModule.forFeature([Post, PostMedia, PostService, Service, Friendship, Subscription]),
    SocialModule,
    CommonModule,
  ],
  controllers: [PostsController],
  providers: [PostsService],
  exports: [PostsService],
})
export class PostsModule {}
