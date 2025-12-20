class Master {
  final String id;
  final String name;
  final String category;
  final double rating;
  final int reviewsCount;
  final double distance; // в км
  final String priceFrom;
  final String avatar;
  final bool verified;
  final String? bio;
  final String? address;
  final List<String>? portfolio;

  Master({
    required this.id,
    required this.name,
    required this.category,
    required this.rating,
    required this.reviewsCount,
    required this.distance,
    required this.priceFrom,
    required this.avatar,
    this.verified = false,
    this.bio,
    this.address,
    this.portfolio,
  });
}
