class Tattoo {
  final String id;
  final String name;
  final String imageUrl;
  final String artistFullName;
  final double price;

  Tattoo({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.artistFullName,
    required this.price,
  });

  factory Tattoo.fromMap(Map<String, dynamic> map) {
    return Tattoo(
      id: map['id'],
      name: map['name'],
      imageUrl: map['imageUrl'],
      artistFullName: map['artistFullName'],
      price: map['price'].toDouble(),
    );
  }
}