import { DataSource } from 'typeorm';
import * as bcrypt from 'bcrypt';
import { User } from '../../modules/users/entities/user.entity';
import { MasterProfile } from '../../modules/masters/entities/master-profile.entity';
import { Post, PostType, PostPrivacy } from '../../modules/posts/entities/post.entity';
import { PostMedia, MediaType } from '../../modules/posts/entities/post-media.entity';
import { Subscription } from '../../modules/friends/entities/subscription.entity';

export async function seedTestData(dataSource: DataSource) {
  console.log('[SEED] Starting test data seeding...');

  const userRepository = dataSource.getRepository(User);
  const masterProfileRepository = dataSource.getRepository(MasterProfile);
  const postRepository = dataSource.getRepository(Post);
  const postMediaRepository = dataSource.getRepository(PostMedia);
  const subscriptionRepository = dataSource.getRepository(Subscription);

  // Заглушка ImageUploader, чтобы не искать потерянный файл и не качать из интернета
  const imageUploader: any = {
    checkBucket: async () => false,
    uploadFromUrl: async (url: string, bucket: string, prefix: string) => url
  };

  const bucketsReady = false; 

  console.log('[SEED] MinIO buckets skip (logic will be handled by upload-local-images.ts)');

  // Хеш пароля для тестовых пользователей (password: "test123")
  const passwordHash = await bcrypt.hash('test123', 10);

  // Создаем тестовых мастеров
  const masters = [
    {
      email: 'anna.master@test.com',
      phone: '+79001111111',
      first_name: 'Анна',
      last_name: 'Иванова',
      avatar_url: 'https://i.pravatar.cc/150?img=1',
      is_master: true,
      master_profile_completed: true,
      is_verified: true,
      rating: 4.8,
      reviews_count: 45,
      password_hash: passwordHash,
      profile: {
        business_name: 'Салон красоты "Анна"',
        bio: 'Профессиональный парикмахер и стилист с 10-летним опытом работы. Специализируюсь на окрашивании и сложных стрижках.',
        rating: 4.8,
        reviews_count: 45,
        completed_bookings: 120,
        location_lat: 55.7558,
        location_lng: 37.6173,
        location_address: 'Москва, ул. Тверская, 10',
        location_name: 'Центр',
        is_mobile: false,
        has_location: true,
        years_of_experience: 10,
        languages: ['ru', 'en'],
        is_active: true,
        is_approved: true,
        setup_step: 5,
      },
    },
    {
      email: 'dmitry.master@test.com',
      phone: '+79002222222',
      first_name: 'Дмитрий',
      last_name: 'Петров',
      avatar_url: 'https://i.pravatar.cc/150?img=12',
      is_master: true,
      master_profile_completed: true,
      is_verified: true,
      rating: 4.9,
      reviews_count: 78,
      password_hash: passwordHash,
      profile: {
        business_name: 'Барбершоп "Петров"',
        bio: 'Барбер с опытом работы более 8 лет. Классические и современные стрижки, уход за бородой.',
        rating: 4.9,
        reviews_count: 78,
        completed_bookings: 200,
        location_lat: 55.7522,
        location_lng: 37.6156,
        location_address: 'Москва, Пушкинская площадь, 5',
        location_name: 'Пушкинская',
        is_mobile: true,
        has_location: true,
        service_radius_km: 15,
        years_of_experience: 8,
        languages: ['ru'],
        is_active: true,
        is_approved: true,
        setup_step: 5,
      },
    },
    {
      email: 'elena.master@test.com',
      phone: '+79003333333',
      first_name: 'Елена',
      last_name: 'Смирнова',
      avatar_url: 'https://i.pravatar.cc/150?img=5',
      is_master: true,
      master_profile_completed: true,
      is_verified: true,
      rating: 4.7,
      reviews_count: 32,
      password_hash: passwordHash,
      profile: {
        business_name: 'Студия маникюра "ElenaNails"',
        bio: 'Nail-мастер, специализируюсь на сложном дизайне и наращивании ногтей.',
        rating: 4.7,
        reviews_count: 32,
        completed_bookings: 85,
        location_lat: 55.7617,
        location_lng: 37.6066,
        location_address: 'Москва, ул. Арбат, 25',
        location_name: 'Арбат',
        is_mobile: false,
        has_location: true,
        years_of_experience: 5,
        languages: ['ru'],
        is_active: true,
        is_approved: true,
        setup_step: 5,
      },
    },
  ];

  // Создаем тестовых учеников (клиентов)
  const students = [
    {
      email: 'maria.student@test.com',
      phone: '+79004444444',
      first_name: 'Мария',
      last_name: 'Козлова',
      avatar_url: 'https://i.pravatar.cc/150?img=9',
      is_master: false,
      password_hash: passwordHash,
    },
    {
      email: 'ivan.student@test.com',
      phone: '+79005555555',
      first_name: 'Иван',
      last_name: 'Сидоров',
      avatar_url: 'https://i.pravatar.cc/150?img=13',
      is_master: false,
      password_hash: passwordHash,
    },
    {
      email: 'olga.student@test.com',
      phone: '+79006666666',
      first_name: 'Ольга',
      last_name: 'Васильева',
      avatar_url: 'https://i.pravatar.cc/150?img=10',
      is_master: false,
      password_hash: passwordHash,
    },
  ];

  console.log('Creating test users...');

  // Сохраняем мастеров
  const savedMasters = [];
  for (const masterData of masters) {
    const { profile, ...userData } = masterData;

    // Скрипт просто пропустит это, используя URL из массива выше
    if (bucketsReady && userData.avatar_url) {
      try {
        userData.avatar_url = await imageUploader.uploadFromUrl(
          userData.avatar_url,
          'avatars',
          `master-${masterData.email.split('@')[0]}`,
        );
      } catch (error) {
        console.log(`[WARN] Failed to upload avatar for ${masterData.email}`);
      }
    }

    const user = userRepository.create(userData);
    const savedUser = await userRepository.save(user);
    savedMasters.push(savedUser);

    const masterProfile = masterProfileRepository.create({
      ...profile,
      user_id: savedUser.id,
    });
    await masterProfileRepository.save(masterProfile);

    console.log('[OK] Created master:', savedUser.full_name);
  }

  // Сохраняем учеников
  const savedStudents = [];
  for (const studentData of students) {
    if (bucketsReady && studentData.avatar_url) {
      try {
        studentData.avatar_url = await imageUploader.uploadFromUrl(
          studentData.avatar_url,
          'avatars',
          `student-${studentData.email.split('@')[0]}`,
        );
      } catch (error) {
        console.log(`[WARN] Failed to upload avatar for ${studentData.email}`);
      }
    }

    const user = userRepository.create(studentData);
    const savedUser = await userRepository.save(user);
    savedStudents.push(savedUser);
    console.log('[OK] Created student:', savedUser.full_name);
  }

  console.log('\nCreating test posts...');

  const postContents = [
    { content: 'Сегодня создала потрясающий образ для моей клиентки!' },
    { content: 'Классическая стрижка каскад - идеальный выбор.' },
    { content: 'Новый тренд сезона - естественное окрашивание.' },
    { content: 'Прошла курсы повышения квалификации!' },
    { content: 'Акция на эту неделю! Скидка 15%.' },
    { content: 'Классическая мужская стрижка никогда не выходит из моды.' },
    { content: 'Современный fade - популярная техника.' },
    { content: 'Стрижка бороды - это искусство!' },
    { content: 'Новая техника текстурной стрижки.' },
    { content: 'Детские стрижки - работаю бережно.' },
    { content: 'Новая коллекция дизайнов уже доступна!' },
    { content: 'Гель-лак с витаминным покрытием.' },
    { content: 'Геометрический дизайн ногтей - хит сезона!' },
    { content: 'Спасибо моим постоянным клиентам за доверие!' },
  ];

  const savedPosts = [];
  let postIndex = 0;
  const postsPerMaster = [5, 5, 4];

  for (let i = 0; i < savedMasters.length; i++) {
    const master = savedMasters[i];
    const postsCount = postsPerMaster[i];

    for (let j = 0; j < postsCount; j++) {
      const postContent = postContents[postIndex];
      const post = postRepository.create({
        author_id: master.id,
        type: PostType.TEXT,
        content: postContent.content,
        privacy: PostPrivacy.PUBLIC,
        likes_count: Math.floor(Math.random() * 50),
        comments_count: Math.floor(Math.random() * 20),
        views_count: Math.floor(Math.random() * 200),
        created_at: new Date(),
      });
      const savedPost = await postRepository.save(post);
      savedPosts.push(savedPost);

      const media = postMediaRepository.create({
        post_id: savedPost.id,
        type: MediaType.PHOTO,
        url: `https://picsum.photos/400/400?random=${postIndex}`,
        thumbnail_url: `https://picsum.photos/400/400?random=${postIndex}`,
        width: 400,
        height: 400,
        order: 0,
      });
      await postMediaRepository.save(media);
      postIndex++;
    }
  }

  console.log('\nCreating test subscriptions...');
  for (const student of savedStudents) {
    const shuffledMasters = [...savedMasters].sort(() => Math.random() - 0.5);
    for (let i = 0; i < 2; i++) {
      const master = shuffledMasters[i];
      const subscription = subscriptionRepository.create({
        subscriber_id: student.id,
        target_id: master.id,
        notifications_enabled: true,
      });
      await subscriptionRepository.save(subscription);
    }
  }

  console.log('\n[DONE] Test data seeding completed!');
}