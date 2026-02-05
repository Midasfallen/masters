# Сборка APK для Service Platform v2.0

Инструкции по сборке Android APK для прототипа.

---

## 🚀 Автоматическая сборка (GitHub Actions)

APK собирается автоматически при:
- Push в ветку `main` или `claude/**`
- Создании Pull Request
- Ручном запуске workflow

### Скачать APK:

1. Перейдите в **Actions** → **Build Flutter APK**
2. Выберите последний успешный workflow run
3. Скачайте артефакт **app-release-apk**
4. Распакуйте ZIP и установите `app-release.apk` на Android устройство

**Прямая ссылка**: https://github.com/Midasfallen/masters/actions

---

## 🛠 Локальная сборка

### Предварительные требования

1. **Flutter SDK** 3.24.0 или новее
   ```bash
   flutter --version
   # Flutter 3.24.0 • channel stable
   ```

2. **Java JDK** 17
   ```bash
   java -version
   # openjdk version "17.0.x"
   ```

3. **Android SDK** (через Android Studio или командной строки)

### Шаги сборки

#### 1. Создать Android структуру проекта (если еще нет)

```bash
cd frontend

# Создать Android платформу
flutter create --platforms=android .
```

#### 2. Установить зависимости

```bash
# Установить Flutter пакеты
flutter pub get

# Сгенерировать Freezed код
flutter pub run build_runner build --delete-conflicting-outputs
```

#### 3. Собрать APK

```bash
# Release APK (оптимизированный)
flutter build apk --release

# APK будет в:
# build/app/outputs/flutter-apk/app-release.apk
```

#### 4. Установить на устройство

```bash
# Через ADB
adb install build/app/outputs/flutter-apk/app-release.apk

# Или скопируйте APK на устройство и установите вручную
```

---

## 📦 Типы сборок

### Release APK (рекомендуется)

```bash
flutter build apk --release
```
- ✅ Минимальный размер (~15-25 MB)
- ✅ Оптимизирован для production
- ❌ Нет debug инструментов

### Debug APK

```bash
flutter build apk --debug
```
- ✅ Включает debug символы
- ✅ Hot reload через WiFi
- ❌ Больший размер (~40-60 MB)

### Profile APK

```bash
flutter build apk --profile
```
- ✅ Профилирование производительности
- ❌ Средний размер (~30-40 MB)

---

## 🔧 Дополнительные опции

### Split APKs по ABI

Создать отдельные APK для каждой архитектуры (меньший размер):

```bash
flutter build apk --release --split-per-abi
```

Результат:
- `app-armeabi-v7a-release.apk` (~12 MB) - для старых устройств
- `app-arm64-v8a-release.apk` (~13 MB) - для современных устройств
- `app-x86_64-release.apk` (~14 MB) - для эмуляторов

### Обфускация кода

```bash
flutter build apk --release --obfuscate --split-debug-info=./debug-info
```

### Версионирование

Обновите `pubspec.yaml`:
```yaml
version: 2.0.0+1  # 2.0.0 = версия, +1 = build number
```

Затем:
```bash
flutter build apk --release --build-name=2.0.0 --build-number=1
```

---

## 🐛 Решение проблем

### Ошибка: "Android toolchain not found"

```bash
# Установите Android SDK через Android Studio
# Или через командную строку:
flutter doctor --android-licenses
```

### Ошибка: "Gradle build failed"

```bash
# Очистите кэш
cd android
./gradlew clean
cd ..

# Попробуйте снова
flutter build apk --release
```

### Ошибка: "Freezed code not generated"

```bash
# Запустите генератор кода
flutter pub run build_runner build --delete-conflicting-outputs

# Затем соберите APK
flutter build apk --release
```

### Ошибка: "Out of memory"

Увеличьте heap size для Gradle:

Создайте `android/gradle.properties`:
```properties
org.gradle.jvmargs=-Xmx4096m
```

---

## 📊 Размер APK

Типичные размеры для прототипа:

| Тип сборки | Размер | Использование |
|------------|--------|---------------|
| Release APK | ~15-25 MB | Production, распространение |
| Release APK (split) | ~12-14 MB | Production, по архитектуре |
| Debug APK | ~40-60 MB | Development, тестирование |
| Profile APK | ~30-40 MB | Профилирование |

---

## 🔒 Подписание APK (для production)

### 1. Создать keystore

```bash
keytool -genkey -v -keystore ~/upload-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias upload
```

### 2. Настроить signing в `android/app/build.gradle`

```gradle
android {
    ...
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile file(keystoreProperties['storeFile'])
            storePassword keystoreProperties['storePassword']
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release
        }
    }
}
```

### 3. Создать `android/key.properties`

```properties
storePassword=<password>
keyPassword=<password>
keyAlias=upload
storeFile=<путь к upload-keystore.jks>
```

⚠️ **НЕ КОММИТЬТЕ** `key.properties` в Git!

---

## 📱 Установка APK

### Через ADB

```bash
# Подключите устройство по USB
adb devices

# Установите APK
adb install -r build/app/outputs/flutter-apk/app-release.apk
```

### Вручную

1. Скопируйте APK на устройство
2. Откройте APK в файловом менеджере
3. Разрешите установку из неизвестных источников
4. Нажмите "Установить"

---

## ✅ Проверка APK

### Размер APK

```bash
du -h build/app/outputs/flutter-apk/app-release.apk
```

### Содержимое APK

```bash
# Распаковать APK
unzip -l build/app/outputs/flutter-apk/app-release.apk

# Проверить библиотеки
unzip -l build/app/outputs/flutter-apk/app-release.apk | grep "\.so"
```

### APK Analyzer (Android Studio)

1. Откройте Android Studio
2. **Build** → **Analyze APK**
3. Выберите `app-release.apk`
4. Просмотрите размеры компонентов

---

## 🚀 Быстрый старт

Одной командой:

```bash
cd frontend && \
flutter create --platforms=android . && \
flutter pub get && \
flutter pub run build_runner build --delete-conflicting-outputs && \
flutter build apk --release && \
echo "✅ APK готов: build/app/outputs/flutter-apk/app-release.apk"
```

---

## 📝 Заметки

- **Прототип v2.0** использует mock data (Faker)
- После первого запуска APK будет работать без интернета (кроме загрузки фото)
- APK содержит 50 постов, 20 пользователей, 10 чатов
- Минимальная версия Android: **5.0 (API 21)**
- Целевая версия Android: **14 (API 34)**

---

**Версия**: 2.0.0
**Flutter**: 3.24.0
**Build Date**: 2025-12-28
