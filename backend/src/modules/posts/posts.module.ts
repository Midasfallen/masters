import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { PostsController } from './posts.controller';
import { PostsService } from './posts.service';
import { Post } from './entities/post.entity';
import { PostMedia } from './entities/post-media.entity';
import { Friendship } from '../friends/entities/friendship.entity';
import { Subscription } from '../friends/entities/subscription.entity';
import { SocialModule } from '../social/social.module';

@Module({
  imports: [
    TypeOrmModule.forFeature([Post, PostMedia, Friendship, Subscription]),
    SocialModule,
  ],
  controllers: [PostsController],
  providers: [PostsService],
  exports: [PostsService],
})
export class PostsModule {}
