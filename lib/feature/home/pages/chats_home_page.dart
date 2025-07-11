import 'package:flutter/material.dart';
import 'package:whatsapp_clone/common/routes/routes.dart';

class ChatsHomePage extends StatelessWidget {
  const ChatsHomePage({super.key});

  navigateToContactsPage(context) {
    Navigator.pushNamed(context, Routes.conatcts);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => navigateToContactsPage(context),
        child: Icon(Icons.chat),
      ),
    );
  }
}
