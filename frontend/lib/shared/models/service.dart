class Service {
  final String id;
  final String name;
  final String category;
  final int durationMinutes;
  final String price;
  final String? description;

  Service({
    required this.id,
    required this.name,
    required this.category,
    required this.durationMinutes,
    required this.price,
    this.description,
  });
}
