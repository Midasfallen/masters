# i18n - Internationalization Files

This directory contains translation files for the Service Platform catalog in 5 languages.

## Languages

- 🇬🇧 **EN** - English (international, default) - `catalog_en.json`
- 🇷🇺 **RU** - Russian (main market) - `catalog_ru.json`
- 🇩🇪 **DE** - German (Europe) - `catalog_de.json`
- 🇪🇸 **ES** - Spanish (Spain, Latin America) - `catalog_es.json`
- 🇫🇷 **FR** - French (France) - `catalog_fr.json`

## Structure

Each `catalog_{lang}.json` file contains:

```json
{
  "categories": {
    "beauty": "Category translation",
    ...
  },
  "subcategories": {
    "hairdressing": "Subcategory translation",
    ...
  },
  "services": {
    "men_haircut": "Service translation",
    ...
  }
}
```

### Statistics

- **10 categories** - Top-level service categories
- **53 subcategories** - Service subcategories
- **340+ services** - Individual services

All translations use `snake_case` keys and are consistent across all 5 languages.

## Usage

### Backend (NestJS)

These JSON files should be placed in `backend/src/i18n/{lang}/catalog.json`.

```typescript
import { I18nService } from 'nestjs-i18n';

const categoryName = await this.i18n.translate('catalog.categories.beauty', { lang: 'en' });
// Returns: "Beauty & Care"
```

### Frontend (Flutter)

Convert to ARB format for Flutter's localization system.

```dart
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final l10n = AppLocalizations.of(context)!;
final categoryName = l10n.category_beauty;
// Returns: "Beauty & Care"
```

## Adding New Translations

1. Add new key to **all 5 language files**
2. Use `snake_case` format for keys
3. Ensure consistency across all files
4. Run `npm run i18n:check` to verify (if available)

## Translation Coverage

✅ All 10 categories translated
✅ All 53 subcategories translated
✅ All 340+ services translated

## Related Documentation

- [i18n Technical Specification](../technical/i18n.md) - Complete i18n architecture
- [Catalog](../business/Catalog.md) - Original catalog structure (Russian)

---

**Last Updated:** December 2025
