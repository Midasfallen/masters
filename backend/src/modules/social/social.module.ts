import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { LikesController } from './likes.controller';
import { LikesService } from './likes.service';
import { CommentsController } from './comments.controller';
import { CommentsService } from './comments.service';
import { RepostsController } from './reposts.controller';
import { RepostsService } from './reposts.service';
import { Like } from './entities/like.entity';
import { Comment } from './entities/comment.entity';
import { Repost } from './entities/repost.entity';
import { Post } from '../posts/entities/post.entity';
import { WebSocketModule } from '../websocket/websocket.module';
import { CacheService } from '../../common/services/cache.service';

@Module({
  imports: [
    TypeOrmModule.forFeature([Like, Comment, Repost, Post]),
    WebSocketModule,
  ],
  controllers: [LikesController, CommentsController, RepostsController],
  providers: [LikesService, CommentsService, RepostsService, CacheService],
  exports: [LikesService, CommentsService, RepostsService, CacheService],
})
export class SocialModule {}
