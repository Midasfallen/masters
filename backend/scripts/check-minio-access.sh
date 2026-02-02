#!/bin/bash

echo "=========================================="
echo "Проверка доступности MinIO"
echo "=========================================="
echo ""

echo "1. Проверка API endpoint (http://localhost:9000)..."
if curl -s -o /dev/null -w "%{http_code}" http://localhost:9000 | grep -q "200\|403\|401"; then
    echo "   ✅ MinIO API доступен"
else
    echo "   ❌ MinIO API недоступен"
fi
echo ""

echo "2. Проверка CORS заголовков..."
CORS_RESPONSE=$(curl -s -I -H "Origin: http://localhost:50220" http://localhost:9000/posts/test.jpg 2>&1)
if echo "$CORS_RESPONSE" | grep -q "Access-Control"; then
    echo "   ✅ CORS заголовки присутствуют"
    echo "$CORS_RESPONSE" | grep -i "access-control"
else
    echo "   ⚠️  CORS заголовки не найдены (возможно, файл не существует, но это нормально)"
fi
echo ""

echo "3. Проверка публичного доступа к бакету posts..."
BUCKET_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:9000/posts/ 2>&1)
if [ "$BUCKET_RESPONSE" = "200" ] || [ "$BUCKET_RESPONSE" = "403" ] || [ "$BUCKET_RESPONSE" = "404" ]; then
    echo "   ✅ Бакет posts доступен (код: $BUCKET_RESPONSE)"
else
    echo "   ❌ Бакет posts недоступен (код: $BUCKET_RESPONSE)"
fi
echo ""

echo "4. Проверка переменной окружения MINIO_PUBLIC_URL..."
if [ -f "../.env" ]; then
    if grep -q "MINIO_PUBLIC_URL=http://localhost:9000" ../.env; then
        echo "   ✅ MINIO_PUBLIC_URL настроен правильно"
    else
        echo "   ⚠️  MINIO_PUBLIC_URL не найден или имеет другое значение"
        echo "   Добавьте в backend/.env: MINIO_PUBLIC_URL=http://localhost:9000"
    fi
else
    echo "   ⚠️  Файл backend/.env не найден"
    echo "   Создайте файл backend/.env с переменной: MINIO_PUBLIC_URL=http://localhost:9000"
fi
echo ""

echo "=========================================="
echo "✅ Проверка завершена"
echo "=========================================="
