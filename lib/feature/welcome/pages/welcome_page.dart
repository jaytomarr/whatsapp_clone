import 'package:flutter/material.dart';
import 'package:whatsapp_clone/common/extension/custom_theme_extension.dart';
import 'package:whatsapp_clone/common/widgets/custom_elevated_button.dart';
import 'package:whatsapp_clone/feature/auth/pages/login_page.dart';
import 'package:whatsapp_clone/feature/welcome/widgets/langauge_button.dart';
import 'package:whatsapp_clone/feature/welcome/widgets/privacy_and_terms.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 50,
                  vertical: 10,
                ),
                child: Image.asset(
                  'assets/images/circle.png',
                  color: context.theme.circleImageColor,
                ),
              ),
            ),
          ),
          SizedBox(height: 40),
          Expanded(
            child: Column(
              children: [
                Text(
                  'Welcome to WhatsappX',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                PrivacyAndTerms(),
                CustomElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  ),
                  text: 'AGREE AND CONTINUE',
                ),
                SizedBox(height: 50),
                LanguageButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
