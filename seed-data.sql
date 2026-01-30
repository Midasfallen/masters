-- Создаем 4 категории
INSERT INTO categories (id, slug, icon_url, image_url, color, is_active, display_order, level, created_at, updated_at) VALUES
('11111111-1111-1111-1111-111111111111', 'hairdressing', 'http://localhost:9000/avatars/hairdressing-icon.jpg', 'http://localhost:9000/avatars/hairdressing-full.jpg', '#FF5722', true, 0, 0, NOW(), NOW()),
('22222222-2222-2222-2222-222222222222', 'manicure-pedicure', 'http://localhost:9000/avatars/manicure-icon.jpg', 'http://localhost:9000/avatars/manicure-full.jpg', '#FF5722', true, 1, 0, NOW(), NOW()),
('33333333-3333-3333-3333-333333333333', 'massage', 'http://localhost:9000/avatars/massage-icon.jpg', 'http://localhost:9000/avatars/massage-full.jpg', '#FF5722', true, 2, 0, NOW(), NOW()),
('44444444-4444-4444-4444-444444444444', 'makeup', 'http://localhost:9000/avatars/makeup-icon.jpg', 'http://localhost:9000/avatars/makeup-full.jpg', '#FF5722', true, 3, 0, NOW(), NOW());

-- Создаем переводы категорий
INSERT INTO category_translations (id, category_id, language, name, description, keywords) VALUES
('11111111-aaaa-1111-1111-111111111111', '11111111-1111-1111-1111-111111111111', 'ru', 'Парикмахерские услуги', 'Парикмахерские услуги', ARRAY['парикмахер', 'стрижка']),
('22222222-aaaa-2222-2222-222222222222', '22222222-2222-2222-2222-222222222222', 'ru', 'Маникюр и педикюр', 'Маникюр и педикюр', ARRAY['маникюр', 'педикюр']),
('33333333-aaaa-3333-3333-333333333333', '33333333-3333-3333-3333-333333333333', 'ru', 'Массаж', 'Массаж', ARRAY['массаж']),
('44444444-aaaa-4444-4444-444444444444', '44444444-4444-4444-4444-444444444444', 'ru', 'Макияж', 'Макияж', ARRAY['макияж']);

-- Создаем 3 пользователей-мастеров (с хешированным паролем)
INSERT INTO users (id, email, phone, first_name, last_name, avatar_url, password_hash, is_master, is_active, created_at, updated_at) VALUES
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'anna.master@test.com', '+79001111111', 'Анна', 'Иванова', 'http://localhost:9000/avatars/anna-avatar.jpg', '$2b$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcg7b3XeKeUxWdeS86E36gZvVOe', true, true, NOW(), NOW()),
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'dmitry.master@test.com', '+79002222222', 'Дмитрий', 'Петров', 'http://localhost:9000/avatars/dmitry-avatar.jpg', '$2b$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcg7b3XeKeUxWdeS86E36gZvVOe', true, true, NOW(), NOW()),
('cccccccc-cccc-cccc-cccc-cccccccccccc', 'elena.master@test.com', '+79003333333', 'Елена', 'Сидорова', 'http://localhost:9000/avatars/elena-avatar.jpg', '$2b$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcg7b3XeKeUxWdeS86E36gZvVOe', true, true, NOW(), NOW());

-- Создаем профили мастеров с категориями
INSERT INTO master_profiles (id, user_id, business_name, bio, rating, reviews_count, completed_bookings, location_lat, location_lng, location_address, category_ids, is_active, created_at, updated_at) VALUES
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa1', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Салон красоты "Элита"', 'Опытный парикмахер с 10-летним стажем', 4.8, 125, 340, 55.7558, 37.6173, 'ул. Красная, 10, Москва', ARRAY['11111111-1111-1111-1111-111111111111']::uuid[], true, NOW(), NOW()),
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbb1', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'Студия красоты Дмитрия', 'Мастер-универсал. Стрижки и окрашивание', 4.9, 98, 215, 55.7658, 37.6273, 'ул. Советская, 5, Москва', ARRAY['11111111-1111-1111-1111-111111111111']::uuid[], true, NOW(), NOW()),
('cccccccc-cccc-cccc-cccc-ccccccccccc1', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'Маникюр кабинет "Лаванда"', 'Специалист по маникюру и педикюру. 8 лет опыта', 4.7, 156, 420, 55.7458, 37.6073, 'ул. Лесная, 15, Москва', ARRAY['22222222-2222-2222-2222-222222222222']::uuid[], true, NOW(), NOW());

-- Создаем 6 постов от мастеров
INSERT INTO posts (id, author_id, type, privacy, content, likes_count, comments_count, created_at, updated_at) VALUES
('dddddddd-dddd-dddd-dddd-dddddddddd01', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'text', 'public', 'Открыла салон красоты! Приглашаю всех на стрижку и окрашивание', 0, 0, NOW(), NOW()),
('dddddddd-dddd-dddd-dddd-dddddddddd02', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'text', 'public', 'Новая коллекция красок для волос уже в наличии!', 0, 0, NOW(), NOW()),
('dddddddd-dddd-dddd-dddd-dddddddddd03', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'text', 'public', 'Тренд 2026: натуральные цвета волос. Советую всем', 0, 0, NOW(), NOW()),
('dddddddd-dddd-dddd-dddd-dddddddddd04', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'text', 'public', 'Специальное предложение на мелирование 30%', 0, 0, NOW(), NOW()),
('dddddddd-dddd-dddd-dddd-dddddddddd05', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'text', 'public', 'Премиум уход за ногтями. Записывайтесь!', 0, 0, NOW(), NOW()),
('dddddddd-dddd-dddd-dddd-dddddddddd06', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'text', 'public', 'Гель-лак держит 4 недели. Безопасно для ногтей', 0, 0, NOW(), NOW());

-- Добавляем изображения к постам
INSERT INTO post_media (id, post_id, url, type, "order") VALUES
('eeeeeeee-eeee-eeee-eeee-eeeeeeeeee01', 'dddddddd-dddd-dddd-dddd-dddddddddd01', 'http://localhost:9000/avatars/hairdressing-full.jpg', 'photo', 0),
('eeeeeeee-eeee-eeee-eeee-eeeeeeeeee02', 'dddddddd-dddd-dddd-dddd-dddddddddd02', 'http://localhost:9000/avatars/hairdressing-full.jpg', 'photo', 0),
('eeeeeeee-eeee-eeee-eeee-eeeeeeeeee03', 'dddddddd-dddd-dddd-dddd-dddddddddd03', 'http://localhost:9000/avatars/hairdressing-full.jpg', 'photo', 0),
('eeeeeeee-eeee-eeee-eeee-eeeeeeeeee04', 'dddddddd-dddd-dddd-dddd-dddddddddd04', 'http://localhost:9000/avatars/hairdressing-full.jpg', 'photo', 0),
('eeeeeeee-eeee-eeee-eeee-eeeeeeeeee05', 'dddddddd-dddd-dddd-dddd-dddddddddd05', 'http://localhost:9000/avatars/manicure-full.jpg', 'photo', 0),
('eeeeeeee-eeee-eeee-eeee-eeeeeeeeee06', 'dddddddd-dddd-dddd-dddd-dddddddddd06', 'http://localhost:9000/avatars/manicure-full.jpg', 'photo', 0);

-- Проверяем результаты
SELECT COUNT(*) as total_posts FROM posts;
SELECT COUNT(*) as total_categories FROM categories;
SELECT COUNT(*) as total_users FROM users;
SELECT COUNT(*) as total_media FROM post_media;
