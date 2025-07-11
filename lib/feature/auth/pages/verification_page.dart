import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/common/extension/custom_theme_extension.dart';
import 'package:whatsapp_clone/common/widgets/custom_icon_button.dart';
import 'package:whatsapp_clone/feature/auth/controller/auth_controller.dart';
import 'package:whatsapp_clone/feature/auth/widgets/custom_text_field.dart';

class VerificationPage extends ConsumerWidget {
  const VerificationPage({
    super.key,
    required this.smsCodeId,
    required this.phoneNumber,
  });

  final String smsCodeId;
  final String phoneNumber;

  void verifySmsCode(BuildContext context, String smsCode, WidgetRef ref) {
    ref
        .read(authControllerProvider)
        .verifySmsCode(
          context: context,
          smsCodeId: smsCodeId,
          smsCode: smsCode,
          mounted: true,
        );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: Text(
          'Verify your number',
          style: TextStyle(color: context.theme.authAppBarTextColor),
        ),
        centerTitle: true,
        actions: [CustomIconButton(onTap: () {}, icon: Icons.more_vert)],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text:
                      "You've tried to register +91 8287825969. Wait before requesting an SMS or call with your code",
                  children: [
                    TextSpan(
                      text: 'Wrong number?',
                      style: TextStyle(color: context.theme.blueColor),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 80),
              child: CustomTextField(
                hintText: "- - -  - - -",
                autoFocus: true,
                fontSize: 30,
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  if (value.length == 6) {
                    return verifySmsCode(context, value, ref);
                  }
                },
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Enter 6-digit code',
              style: TextStyle(color: context.theme.greyColor),
            ),
            SizedBox(height: 30),
            Row(
              children: [
                Icon(Icons.message, color: context.theme.greyColor),
                SizedBox(width: 20),
                Text(
                  'Resend SMS',
                  style: TextStyle(color: context.theme.greyColor),
                ),
              ],
            ),
            SizedBox(height: 10),
            Divider(color: context.theme.blueColor!.withValues(alpha: 0.2)),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.phone, color: context.theme.greyColor),
                SizedBox(width: 20),
                Text('Call', style: TextStyle(color: context.theme.greyColor)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
