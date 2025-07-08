import 'package:cloud_firestore/cloud_firestore.dart';

class Plant {
  final String name;              // 'nama' di Firestore
  final String category;          // 'kategori'
  final String description;       // 'deskripsi'
  final String careInstructions;  // 'perawatan'
  final String built;             // 'dibuat'
  final String type;              // 'jenis'
  final String imageAsset;        // lokal, bukan dari Firestore
  final List<String> imageUrls;   // 'gambar_url' atau 'imageUrls'
  final String encyclopedia;      // 'ensiklopedia'
  final bool isFavorite;          // lokal saja

  Plant({
    required this.name,
    required this.category,
    required this.description,
    required this.careInstructions,
    required this.built,
    required this.type,
    required this.imageAsset,
    required this.imageUrls,
    required this.encyclopedia,
    this.isFavorite = false,
  });

  factory Plant.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Plant(
      name: data['nama'] ?? '',
      category: data['kategori'] ?? '',
      description: data['deskripsi'] ?? '',
      careInstructions: data['perawatan'] ?? '',
      built: data['dibuat'] ?? '',
      type: data['jenis'] ?? '',
      imageAsset: '', // Kosong karena dari lokal
      imageUrls: data['imageUrls'] != null
          ? List<String>.from(data['imageUrls'])
          : data['gambar_url'] != null
              ? [data['gambar_url']]
              : [],
      encyclopedia: data['ensiklopedia'] ?? '',
      isFavorite: false, // Tetap lokal
    );
  }
}
