import { Like } from './entities/like.entity';
import { Comment } from './entities/comment.entity';
import { Repost } from './entities/repost.entity';
import { LikeResponseDto } from './dto/like-response.dto';
import { CommentResponseDto } from './dto/comment-response.dto';
import { RepostResponseDto } from './dto/repost-response.dto';

/**
 * Mapper для преобразования Social entities → Response DTOs
 */
export class SocialMapper {
  /**
   * Преобразует Like entity в LikeResponseDto
   */
  static toLikeDto(like: Like): LikeResponseDto {
    return {
      id: like.id,
      userId: like.user_id,
      likableType: like.likable_type,
      likableId: like.likable_id,
      createdAt: like.created_at,
    };
  }

  /**
   * Преобразует массив Like entities в массив LikeResponseDto
   */
  static toLikeDtoArray(likes: Like[]): LikeResponseDto[] {
    return likes.map((like) => this.toLikeDto(like));
  }

  /**
   * Преобразует Comment entity в CommentResponseDto
   */
  static toCommentDto(comment: Comment): CommentResponseDto {
    return {
      id: comment.id,
      postId: comment.post_id,
      authorId: comment.author_id,
      content: comment.content,
      parentCommentId: comment.parent_comment_id,
      likesCount: comment.likes_count,
      repliesCount: comment.replies_count,
      isEdited: comment.is_edited,
      createdAt: comment.created_at,
      updatedAt: comment.updated_at,
    };
  }

  /**
   * Преобразует массив Comment entities в массив CommentResponseDto
   */
  static toCommentDtoArray(comments: Comment[]): CommentResponseDto[] {
    return comments.map((comment) => this.toCommentDto(comment));
  }

  /**
   * Преобразует Repost entity в RepostResponseDto
   */
  static toRepostDto(repost: Repost): RepostResponseDto {
    return {
      id: repost.id,
      userId: repost.user_id,
      postId: repost.post_id,
      comment: repost.comment,
      createdAt: repost.created_at,
    };
  }

  /**
   * Преобразует массив Repost entities в массив RepostResponseDto
   */
  static toRepostDtoArray(reposts: Repost[]): RepostResponseDto[] {
    return reposts.map((repost) => this.toRepostDto(repost));
  }
}
