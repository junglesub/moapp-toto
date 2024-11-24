import 'package:flutter/material.dart';

class AddPage extends StatelessWidget {
  const AddPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('오늘의 기록'),
      ),
      body: const Center(
        child: Text('Page Body'),
      ),
    );
  }
}
