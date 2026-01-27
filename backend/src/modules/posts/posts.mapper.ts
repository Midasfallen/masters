import { Post } from './entities/post.entity';
import { PostMedia } from './entities/post-media.entity';
import { User } from '../users/entities/user.entity';
import { PostResponseDto } from './dto/post-response.dto';
import { PostMediaResponseDto } from './dto/post-media-response.dto';
import { AuthUserDto } from '../auth/dto/auth-response.dto';

/**
 * Mapper для преобразования Post Entity → PostResponseDto
 */
export class PostsMapper {
  /**
   * Преобразует User entity в AuthUserDto (упрощенный пользователь)
   */
  static toUserDto(user: User): AuthUserDto {
    return {
      id: user.id,
      email: user.email,
      firstName: user.first_name,
      lastName: user.last_name,
      avatarUrl: user.avatar_url,
      isMaster: user.is_master,
      isVerified: user.is_verified,
      isPremium: user.is_premium,
    };
  }

  /**
   * Преобразует PostMedia entity в PostMediaResponseDto
   */
  static toMediaDto(media: PostMedia): PostMediaResponseDto {
    return {
      id: media.id,
      postId: media.post_id,
      type: media.type,
      url: media.url,
      thumbnailUrl: media.thumbnail_url,
      order: media.order,
      width: media.width,
      height: media.height,
      duration: media.duration,
    };
  }

  /**
   * Преобразует Post entity в PostResponseDto
   * @param post - Post entity с loaded relations (author, media, repost_of)
   */
  static toDto(post: Post): PostResponseDto {
    return {
      id: post.id,
      authorId: post.author_id,
      type: post.type,
      content: post.content,
      privacy: post.privacy,
      repostOfId: post.repost_of_id,
      likesCount: post.likes_count,
      commentsCount: post.comments_count,
      repostsCount: post.reposts_count,
      viewsCount: post.views_count,
      locationLat: post.location_lat,
      locationLng: post.location_lng,
      locationName: post.location_name,
      commentsDisabled: post.comments_disabled,
      isPinned: post.is_pinned,
      createdAt: post.created_at,
      updatedAt: post.updated_at,
      author: post.author ? this.toUserDto(post.author) : null,
      media: post.media ? post.media.map(m => this.toMediaDto(m)) : [],
      repostOf: post.repost_of ? this.toDto(post.repost_of) : null,
    };
  }

  /**
   * Преобразует массив Post entities в массив PostResponseDto
   */
  static toDtoArray(posts: Post[]): PostResponseDto[] {
    return posts.map(post => this.toDto(post));
  }
}
