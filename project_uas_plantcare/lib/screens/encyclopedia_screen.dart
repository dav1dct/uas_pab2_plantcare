import 'package:flutter/material.dart';

class EncyclopediaScreen extends StatelessWidget {
  final String encyclopedia;

  const EncyclopediaScreen({super.key, required this.encyclopedia});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Encyclopedia'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Text(
            encyclopedia,
            style: const TextStyle(fontSize: 16, height: 1.5),
          ),
        ),
      ),
    );
  }
}