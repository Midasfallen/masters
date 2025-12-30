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

@Module({
  imports: [TypeOrmModule.forFeature([Like, Comment, Repost, Post])],
  controllers: [LikesController, CommentsController, RepostsController],
  providers: [LikesService, CommentsService, RepostsService],
  exports: [LikesService, CommentsService, RepostsService],
})
export class SocialModule {}
