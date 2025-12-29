# GitHub Actions Workflows

## Build and Release APK

Этот workflow автоматически собирает APK и App Bundle для Android приложения.

### Когда запускается:

1. **Push в main или develop** - собирает APK и загружает как артефакт
2. **Pull Request в main** - собирает APK для проверки
3. **Вручную** - можно запустить через "Actions" -> "Build and Release APK" -> "Run workflow"
4. **Push тега v*** - создаёт GitHub Release с APK файлами

### Как использовать:

#### Скачать APK после коммита:

1. Перейдите в **Actions** на GitHub
2. Выберите последний успешный workflow run
3. Скачайте артефакт **release-apk**
4. Распакуйте архив - внутри будут APK файлы

#### Создать релиз с APK:

```bash
# Создайте тег с версией
git tag v1.0.0

# Запушьте тег
git push origin v1.0.0
```

После этого автоматически создастся Release на GitHub с APK файлами.

### Что собирается:

- **app-arm64-v8a-release.apk** - для современных устройств (64-bit ARM)
- **app-armeabi-v7a-release.apk** - для старых устройств (32-bit ARM)
- **app-x86_64-release.apk** - для x86 устройств/эмуляторов
- **app-release.aab** - App Bundle для Google Play Store

### Требования:

- Flutter 3.24.0
- Java 17
- Все зависимости в frontend/pubspec.yaml
