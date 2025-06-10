import 'package:flutter/material.dart';

class DiscoveryScreen extends StatelessWidget {
  const DiscoveryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Keşfet'),
      ),
      body: const Center(
        child: Text('Keşfet ekranı yakında'),
      ),
    );
  }
}
