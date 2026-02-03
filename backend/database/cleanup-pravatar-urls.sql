-- Очистка ссылок на pravatar.cc из базы данных
-- Выполнить этот скрипт для удаления внешних ссылок, вызывающих CORS ошибки

UPDATE users 
SET avatar_url = NULL 
WHERE avatar_url LIKE '%pravatar%' OR avatar_url LIKE '%pravatar.cc%';

-- Проверка результата
SELECT COUNT(*) as remaining_pravatar_urls 
FROM users 
WHERE avatar_url LIKE '%pravatar%' OR avatar_url LIKE '%pravatar.cc%';
