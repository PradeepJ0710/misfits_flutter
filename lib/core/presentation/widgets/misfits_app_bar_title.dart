import 'package:flutter/material.dart';

class MisfitsAppBarTitle extends StatelessWidget {
  final String title;

  const MisfitsAppBarTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    // Using the primary color as the "App Logo Green"
    final color = Theme.of(context).colorScheme.primary;

    return Text(
      title,
      style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 32),
    );
  }
}
