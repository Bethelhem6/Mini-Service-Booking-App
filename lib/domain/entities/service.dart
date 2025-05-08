class Service {
  final String? id;
  final String name;
  final String category;
  final double price;
  final String imageUrl;
  final bool availability;
  final int duration; // in minutes
  final double rating;

  Service({
    this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.imageUrl,
    required this.availability,
    required this.duration,
    required this.rating,
  });
}
