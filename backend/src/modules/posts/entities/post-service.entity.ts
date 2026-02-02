import {
  Entity,
  Column,
  PrimaryGeneratedColumn,
  CreateDateColumn,
  ManyToOne,
  JoinColumn,
  Index,
} from 'typeorm';
import { ApiProperty } from '@nestjs/swagger';
import { Post } from './post.entity';
import { Service } from '../../services/entities/service.entity';

@Entity('post_services')
@Index(['post_id'])
@Index(['service_id'])
@Index(['post_id', 'service_id'], { unique: true })
export class PostService {
  @ApiProperty()
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @ApiProperty({ description: 'ID поста' })
  @Column({ type: 'uuid' })
  post_id: string;

  @ApiProperty({ description: 'ID услуги' })
  @Column({ type: 'uuid' })
  service_id: string;

  @ApiProperty()
  @CreateDateColumn()
  created_at: Date;

  @ManyToOne(() => Post, (post) => post.post_services, {
    onDelete: 'CASCADE',
  })
  @JoinColumn({ name: 'post_id' })
  post: Post;

  @ManyToOne(() => Service, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'service_id' })
  service: Service;
}
