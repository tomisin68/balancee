class RepairStation {
  final String id;
  final String name;
  final double distance;
  final double rating;
  final String type;

  RepairStation({
    required this.id,
    required this.name,
    required this.distance,
    required this.rating,
    required this.type,
  });

  @override
  String toString() {
    return 'RepairStation{id: $id, name: $name, distance: $distance, rating: $rating, type: $type}';
  }
}