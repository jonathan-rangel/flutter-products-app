import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'List of products',
          ),
        ),
        body: const Center(
          child: CircularProgressIndicator(
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}
