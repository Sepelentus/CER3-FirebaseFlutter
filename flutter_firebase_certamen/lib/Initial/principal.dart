import 'package:flutter/material.dart';

class Principalpage extends StatelessWidget {
  const Principalpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Principal Page'),
      ),
      body: const Center(
        child: Text(
          'This is the Principal Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}