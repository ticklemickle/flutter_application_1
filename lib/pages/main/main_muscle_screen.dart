import 'package:flutter/material.dart';

class MainMuscleScreen extends StatelessWidget {
  const MainMuscleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          child: ListTile(
            title: const Text('부동산'),
            subtitle: const Text('부동산 관련 내용'),
            onTap: () {
              // Navigate to detailed post
            },
          ),
        ),
        Card(
          child: ListTile(
            title: const Text('머니 루틴'),
            subtitle: const Text('머니 루틴 관련 내용'),
            onTap: () {
              // Navigate to detailed post
            },
          ),
        ),
      ],
    );
  }
}
