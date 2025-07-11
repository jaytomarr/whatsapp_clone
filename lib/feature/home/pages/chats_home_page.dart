import 'package:flutter/material.dart';

class ChatsHomePage extends StatelessWidget {
  const ChatsHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.chat),
      ),
    );
  }
}
