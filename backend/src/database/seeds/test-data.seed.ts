import { DataSource } from 'typeorm';
import * as bcrypt from 'bcrypt';
import { User } from '../../modules/users/entities/user.entity';
import { MasterProfile } from '../../modules/masters/entities/master-profile.entity';
import { Post, PostType, PostPrivacy } from '../../modules/posts/entities/post.entity';
import { Subscription } from '../../modules/friends/entities/subscription.entity';

export async function seedTestData(dataSource: DataSource) {
  console.log('🌱 Starting test data seeding...');

  const userRepository = dataSource.getRepository(User);
  const masterProfileRepository = dataSource.getRepository(MasterProfile);
  const postRepository = dataSource.getRepository(Post);
  const subscriptionRepository = dataSource.getRepository(Subscription);

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

    // Создаем пользователя
    const user = userRepository.create(userData);
    const savedUser = await userRepository.save(user);
    savedMasters.push(savedUser);

    // Создаем профиль мастера
    const masterProfile = masterProfileRepository.create({
      ...profile,
      user_id: savedUser.id,
    });
    await masterProfileRepository.save(masterProfile);

    console.log(`✓ Created master: ${savedUser.full_name}`);
  }

  // Сохраняем учеников
  const savedStudents = [];
  for (const studentData of students) {
    const user = userRepository.create(studentData);
    const savedUser = await userRepository.save(user);
    savedStudents.push(savedUser);
    console.log(`✓ Created student: ${savedUser.full_name}`);
  }

  console.log('\nCreating test posts...');

  // Создаем посты для мастеров
  const postContents = [
    {
      type: PostType.TEXT,
      content: '🎨 Сегодня создала потрясающий образ для моей клиентки! Сложное окрашивание в технике балаяж заняло 4 часа, но результат того стоил. Записывайтесь на консультацию!',
    },
    {
      type: PostType.TEXT,
      content: '✂️ Классическая мужская стрижка никогда не выходит из моды. Важно учитывать форму лица и структуру волос. Приходите, подберем идеальный стиль!',
    },
    {
      type: PostType.TEXT,
      content: '💅 Новая коллекция дизайнов уже доступна! Французский маникюр в современной интерпретации, геометрия, абстракция. Жду вас в студии!',
    },
    {
      type: PostType.TEXT,
      content: '👩‍🎨 Прошла курсы повышения квалификации по новым техникам окрашивания. Готова удивлять вас еще более яркими образами!',
    },
    {
      type: PostType.TEXT,
      content: '🔥 Акция! При записи на эту неделю - скидка 15% на все услуги. Количество мест ограничено!',
    },
    {
      type: PostType.TEXT,
      content: '⭐ Спасибо моим постоянным клиентам за доверие! Ваши отзывы вдохновляют меня становиться лучше каждый день.',
    },
  ];

  const savedPosts = [];
  for (let i = 0; i < savedMasters.length; i++) {
    const master = savedMasters[i];

    // Каждый мастер создает 2 поста
    for (let j = 0; j < 2; j++) {
      const postContent = postContents[i * 2 + j];
      const post = postRepository.create({
        author_id: master.id,
        type: postContent.type,
        content: postContent.content,
        privacy: PostPrivacy.PUBLIC,
        likes_count: Math.floor(Math.random() * 50) + 5,
        comments_count: Math.floor(Math.random() * 20),
        views_count: Math.floor(Math.random() * 200) + 50,
        created_at: new Date(Date.now() - Math.random() * 7 * 24 * 60 * 60 * 1000), // Последние 7 дней
      });
      const savedPost = await postRepository.save(post);
      savedPosts.push(savedPost);
      console.log(`✓ Created post by ${master.full_name}`);
    }
  }

  console.log('\nCreating test subscriptions...');

  // Создаем подписки (ученики подписываются на мастеров)
  const subscriptions = [];
  for (const student of savedStudents) {
    // Каждый ученик подписывается на 2 случайных мастеров
    const shuffledMasters = [...savedMasters].sort(() => Math.random() - 0.5);
    for (let i = 0; i < 2; i++) {
      const master = shuffledMasters[i];
      const subscription = subscriptionRepository.create({
        subscriber_id: student.id,
        target_id: master.id,
        notifications_enabled: true,
      });
      await subscriptionRepository.save(subscription);
      subscriptions.push(subscription);
      console.log(`✓ ${student.full_name} subscribed to ${master.full_name}`);
    }
  }

  // Обновляем счетчики подписок
  for (const master of savedMasters) {
    const followersCount = await subscriptionRepository.count({
      where: { target_id: master.id },
    });
    master.followers_count = followersCount;
    await userRepository.save(master);
  }

  for (const student of savedStudents) {
    const followingCount = await subscriptionRepository.count({
      where: { subscriber_id: student.id },
    });
    student.following_count = followingCount;
    await userRepository.save(student);
  }

  console.log('\n✅ Test data seeding completed!');
  console.log(`
📊 Summary:
  - Masters: ${savedMasters.length}
  - Students: ${savedStudents.length}
  - Posts: ${savedPosts.length}
  - Subscriptions: ${subscriptions.length}

🔑 Test credentials:
  Email: any user email above
  Password: test123
  `);
}
