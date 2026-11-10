/// A saved food spot: dish photo, voice-dictated review and GPS location.
class FoodSpot {
  final int? id;
  final String name;
  final String review;
  final String? imagePath;
  final double? latitude;
  final double? longitude;
  final String createdAt;

  const FoodSpot({
    this.id,
    required this.name,
    required this.review,
    this.imagePath,
    this.latitude,
    this.longitude,
    required this.createdAt,
  });

  /// Builds a FoodSpot from a database row.
  factory FoodSpot.fromMap(Map<String, dynamic> map) {
    return FoodSpot(
      id: map['id'] as int?,
      name: map['name'] as String,
      review: map['review'] as String,
      imagePath: map['image_path'] as String?,
      latitude: map['latitude'] as double?,
      longitude: map['longitude'] as double?,
      createdAt: map['created_at'] as String,
    );
  }

  /// Converts this FoodSpot into a database row.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'review': review,
      'image_path': imagePath,
      'latitude': latitude,
      'longitude': longitude,
      'created_at': createdAt,
    };
  }
}
