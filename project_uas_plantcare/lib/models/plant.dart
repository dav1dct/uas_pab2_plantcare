class Plant {
  final String name;
  final String category;
  final String description;
  final String careInstructions;
  final String built;
  final String type;
  final String imageAsset;
  final List<String> imageUrls;
  final String encyclopedia; // Tambahkan properti ini
  final bool isFavorite;

  Plant({
    required this.name,
    required this.category,
    required this.description,
    required this.careInstructions,
    required this.built,
    required this.type,
    required this.imageAsset,
    required this.imageUrls,
    required this.encyclopedia, // Wajib diisi untuk ensiklopedia
    this.isFavorite = false,
  });
}