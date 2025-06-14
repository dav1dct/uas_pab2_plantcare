import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_uas_plantcare/screens/post_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('tanaman')
            .orderBy('created_at', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            debugPrint('Firestore error: ${snapshot.error}');
            return const Center(child: Text('Terjadi kesalahan saat memuat data.'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Belum ada tanaman.'));
          }

          final tanamanDocs = snapshot.data!.docs;

          return GridView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: tanamanDocs.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 0.75,
            ),
            itemBuilder: (context, index) {
              final data = tanamanDocs[index].data() as Map<String, dynamic>;

              final gambarUrl = data['gambar_url']?.toString() ?? '';
              final nama = data['nama'] ?? '';
              final deskripsi = data['deskripsi'] ?? '';

              // Log untuk debugging
              debugPrint('gambar_url: $gambarUrl');

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                        child: gambarUrl.isNotEmpty
                            ? Image.network(
                                gambarUrl,
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return const Center(child: CircularProgressIndicator());
                                },
                                errorBuilder: (context, error, stackTrace) =>
                                    const Center(child: Icon(Icons.broken_image, size: 40)),
                              )
                            : const Center(child: Icon(Icons.image_not_supported, size: 40)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 12, top: 8, right: 12),
                      child: Text(
                        nama,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 12, bottom: 8, right: 12),
                      child: Text(
                        deskripsi,
                        style: const TextStyle(fontSize: 12),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PostScreen()),
          );
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add),
      ),
    );
  }
}
