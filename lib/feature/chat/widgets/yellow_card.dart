import 'package:flutter/material.dart';
import 'package:whatsapp_clone/common/extension/custom_theme_extension.dart';

class YellowCard extends StatelessWidget {
  const YellowCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        'Messages and calls are ened-to-end encrypted. No one outside of this chat, not even WhatsappX, can read or listen to them. Tap to learn more',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 13,
          color: context.theme.yellowCardTextColor,
        ),
      ),
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: context.theme.yelloCardBgColor,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
