import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  Uint8List? _imageBytes;
  bool _isLoading = false;

  final picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _imageBytes = bytes;
      });
    }
  }

  Future<void> _uploadPost() async {
    if (_imageBytes == null || _namaController.text.isEmpty || _deskripsiController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua field dan gambar wajib diisi!')),
      );
      return;
    }

    try {
      setState(() => _isLoading = true);

      final String imageId = const Uuid().v4();
      final storageRef = FirebaseStorage.instance.ref().child('tanaman/$imageId.jpg');

      // Upload image
      await storageRef.putData(_imageBytes!, SettableMetadata(contentType: 'image/jpeg'));

      // Get download URL
      final String downloadURL = await storageRef.getDownloadURL();

      // Simpan ke Firestore
      await FirebaseFirestore.instance.collection('tanaman').add({
        'nama': _namaController.text,
        'deskripsi': _deskripsiController.text,
        'gambar_url': downloadURL,
        'created_at': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Berhasil diunggah!')),
      );

      Navigator.pop(context); // kembali ke home
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal upload: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Tanaman')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _imageBytes != null
                    ? Image.memory(_imageBytes!, fit: BoxFit.cover)
                    : const Center(child: Text('Klik untuk pilih gambar')),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _namaController,
              decoration: const InputDecoration(labelText: 'Nama Tanaman'),
            ),
            TextField(
              controller: _deskripsiController,
              decoration: const InputDecoration(labelText: 'Deskripsi'),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton.icon(
                    onPressed: _uploadPost,
                    icon: const Icon(Icons.upload),
                    label: const Text('Upload'),
                  ),
          ],
        ),
      ),
    );
  }
}
