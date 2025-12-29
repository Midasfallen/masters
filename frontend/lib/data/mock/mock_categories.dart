class ServiceCategory {
  final String id;
  final String name;
  final String icon;
  final List<ServiceCategory>? subcategories;

  ServiceCategory({
    required this.id,
    required this.name,
    required this.icon,
    this.subcategories,
  });
}

final List<ServiceCategory> mockCategories = [
  ServiceCategory(
    id: 'beauty',
    name: 'Красота',
    icon: '💄',
    subcategories: [
      ServiceCategory(
        id: 'hair',
        name: 'Парикмахерские услуги',
        icon: '✂️',
      ),
      ServiceCategory(
        id: 'nails',
        name: 'Ногтевой сервис',
        icon: '💅',
      ),
      ServiceCategory(
        id: 'brows',
        name: 'Брови и ресницы',
        icon: '👁️',
      ),
      ServiceCategory(
        id: 'makeup',
        name: 'Макияж',
        icon: '💋',
      ),
    ],
  ),
  ServiceCategory(
    id: 'health',
    name: 'Здоровье',
    icon: '❤️',
    subcategories: [
      ServiceCategory(
        id: 'massage',
        name: 'Массаж',
        icon: '💆',
      ),
      ServiceCategory(
        id: 'cosmetology',
        name: 'Косметология',
        icon: '🧴',
      ),
      ServiceCategory(
        id: 'depilation',
        name: 'Депиляция',
        icon: '✨',
      ),
    ],
  ),
  ServiceCategory(
    id: 'education',
    name: 'Обучение',
    icon: '📚',
    subcategories: [
      ServiceCategory(
        id: 'tutoring',
        name: 'Репетиторство',
        icon: '👨‍🏫',
      ),
      ServiceCategory(
        id: 'courses',
        name: 'Курсы',
        icon: '🎓',
      ),
      ServiceCategory(
        id: 'fitness',
        name: 'Фитнес и спорт',
        icon: '🏋️',
      ),
    ],
  ),
  ServiceCategory(
    id: 'creative',
    name: 'Творчество',
    icon: '🎨',
    subcategories: [
      ServiceCategory(
        id: 'photo',
        name: 'Фото/Видео',
        icon: '📷',
      ),
      ServiceCategory(
        id: 'tattoo',
        name: 'Тату и пирсинг',
        icon: '🎭',
      ),
      ServiceCategory(
        id: 'styling',
        name: 'Стилистика',
        icon: '👗',
      ),
    ],
  ),
  ServiceCategory(
    id: 'repair',
    name: 'Ремонт',
    icon: '🔧',
    subcategories: [
      ServiceCategory(
        id: 'home',
        name: 'Ремонт дома',
        icon: '🏠',
      ),
      ServiceCategory(
        id: 'auto',
        name: 'Авто',
        icon: '🚗',
      ),
      ServiceCategory(
        id: 'electronics',
        name: 'Электроника',
        icon: '💻',
      ),
    ],
  ),
  ServiceCategory(
    id: 'other',
    name: 'Другое',
    icon: '🌟',
  ),
];
