import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_uas_plantcare/data/plant_data.dart';
import 'package:project_uas_plantcare/models/plant.dart';
import 'package:project_uas_plantcare/screens/detail_screen.dart';
import 'package:project_uas_plantcare/screens/post_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PostScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🌱 TANAMAN LOKAL
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
              child: Text(
                'Tanaman Lokal',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(8),
              itemCount: plantList.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 0.75,
              ),
              itemBuilder: (context, index) {
                final plant = plantList[index];
                return _buildPlantCard(context, plant, useAsset: true);
              },
            ),

            // 🔥 TANAMAN DARI FIRESTORE
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
              child: Text(
                'Tanaman dari Firestore',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('tanaman')
                  .orderBy('created_at', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Center(
                    child: Text('Terjadi kesalahan saat memuat data.'),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('Belum ada tanaman.'));
                }

                final plantDocs = snapshot.data!.docs;
                final firestorePlants = plantDocs.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  return Plant(
                    name: data['nama'] ?? 'Tanpa Nama',
                    category: data['kategori'] ?? '',
                    description: data['deskripsi'] ?? '',
                    careInstructions: data['perawatan'] ?? '',
                    built: data['musim'] ?? '',
                    type: data['tipe'] ?? '',
                    imageAsset: '',
                    imageUrls: [data['gambar_url'] ?? ''],
                    encyclopedia: '',
                  );
                }).toList();

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(8),
                  itemCount: firestorePlants.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 0.75,
                  ),
                  itemBuilder: (context, index) {
                    final plant = firestorePlants[index];
                    return _buildPlantCard(context, plant, useAsset: false);
                  },
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PostScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildPlantCard(BuildContext context, Plant plant, {required bool useAsset}) {
    final image = useAsset
        ? Image.asset(plant.imageAsset, fit: BoxFit.cover)
        : Image.network(
            plant.imageUrls.isNotEmpty ? plant.imageUrls.first : '',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                const Center(child: Icon(Icons.broken_image)),
          );

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DetailScreen(plant: plant)),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: image,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12, top: 8, right: 12),
              child: Text(
                plant.name,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12, bottom: 8, right: 12),
              child: Text(
                plant.type,
                style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
