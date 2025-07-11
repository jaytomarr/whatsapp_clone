import 'package:flutter/material.dart';
import 'package:whatsapp_clone/common/extension/custom_theme_extension.dart';
import 'package:whatsapp_clone/common/models/user_model.dart';
import 'package:whatsapp_clone/common/utils/colors.dart';

class ContactCard extends StatelessWidget {
  const ContactCard({
    super.key,
    required this.contactsSource,
    required this.onTap,
  });

  final UserModel contactsSource;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.only(left: 20, right: 10),
      dense: true,
      leading: CircleAvatar(
        backgroundColor: context.theme.greyColor!.withValues(alpha: 0.3),
        radius: 20,
        backgroundImage: contactsSource.profileImageUrl.isNotEmpty
            ? NetworkImage(contactsSource.profileImageUrl)
            : null,
        child: contactsSource.profileImageUrl.isEmpty
            ? Icon(Icons.person, size: 30, color: Colors.white)
            : SizedBox(),
      ),
      title: Text(
        contactsSource.username,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      subtitle: contactsSource.profileImageUrl.isEmpty
          ? null
          : Text(
              "Hey there! I'm using WhatsappX",
              style: TextStyle(
                color: context.theme.greyColor,
                fontWeight: FontWeight.w400,
              ),
            ),
      trailing: contactsSource.profileImageUrl.isNotEmpty
          ? null
          : TextButton(
              onPressed: onTap,
              style: TextButton.styleFrom(foregroundColor: greenDark),
              child: Text('INVITE'),
            ),
    );
  }
}
