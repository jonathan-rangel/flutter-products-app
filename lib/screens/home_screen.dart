import 'package:flutter/material.dart';

import '../widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('List of products'),
          centerTitle: true,
        ),
        drawer: const SideMenu(),
        body: const Center(
          child: Text('HomeScreen'),
        ),
      ),
    );
  }
}
