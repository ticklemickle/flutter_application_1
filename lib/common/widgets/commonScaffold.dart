import 'package:flutter/material.dart';

class CommonScaffold extends StatelessWidget {
  final Widget child;

  const CommonScaffold({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: statusBarHeight),
        child: child,
      ),
    );
  }
}
