import 'package:flutter/material.dart';

class MainMuscleScreen extends StatelessWidget {
  const MainMuscleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Main Muscle')),
      body: Column(
        children: [
          Card(
            child: ListTile(
              title: Text('부동산'),
              subtitle: Text('부동산 관련 내용'),
              onTap: () {
                // Navigate to detailed post
              },
            ),
          ),
          Card(
            child: ListTile(
              title: Text('머니 루틴'),
              subtitle: Text('머니 루틴 관련 내용'),
              onTap: () {
                // Navigate to detailed post
              },
            ),
          ),
        ],
      ),
    );
  }
}
