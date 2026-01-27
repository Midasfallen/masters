#!/bin/bash

# Скрипт для автоматической миграции Frontend моделей на camelCase
# Убирает @JsonKey(name: 'snake_case') аннотации из response моделей

MODELS_DIR="frontend/lib/core/models/api"

echo "🔄 Начинаем миграцию Frontend моделей..."
echo ""

# Список файлов для обработки (исключая уже мигрированные)
FILES=(
  "master_model.dart"
  "review_model.dart"
  "post_model.dart"
  "user_model.dart"
  "friend_model.dart"
  "auto_proposal_model.dart"
  "premium_subscription_model.dart"
)

for file in "${FILES[@]}"; do
  filepath="$MODELS_DIR/$file"

  if [ ! -f "$filepath" ]; then
    echo "⚠️  Файл не найден: $filepath"
    continue
  fi

  echo "📝 Обрабатываем: $file"

  # Создаем backup
  cp "$filepath" "$filepath.backup"

  # Убираем @JsonKey аннотации из response моделей
  # Оставляем @JsonKey в Request моделях (они идут после комментария /// или @freezed class *Request)

  # Простая замена - убираем все @JsonKey(name: '...') но оставляем имя поля
  sed -i.tmp 's/@JsonKey(name: '"'"'[a-z_]*'"'"') //g' "$filepath"

  # Убираем лишние пробелы
  sed -i.tmp 's/  */ /g' "$filepath"

  # Удаляем временные файлы
  rm -f "$filepath.tmp"

  echo "✅ Обновлен: $file"
done

echo ""
echo "🎉 Миграция завершена!"
echo ""
echo "📌 Следующие шаги:"
echo "1. Проверьте изменения: git diff frontend/lib/core/models/api/"
echo "2. Пересоберите Freezed файлы: cd frontend && flutter pub run build_runner build --delete-conflicting-outputs"
echo "3. Проверьте компиляцию: flutter analyze"
echo "4. Запустите тесты: flutter test"
echo ""
echo "💾 Backup файлы сохранены с расширением .backup"
