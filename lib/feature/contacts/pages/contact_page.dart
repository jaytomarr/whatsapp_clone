import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_clone/common/extension/custom_theme_extension.dart';
import 'package:whatsapp_clone/common/models/user_model.dart';
import 'package:whatsapp_clone/common/routes/routes.dart';
import 'package:whatsapp_clone/common/utils/colors.dart';
import 'package:whatsapp_clone/common/widgets/custom_icon_button.dart';
import 'package:whatsapp_clone/feature/contacts/controllers/contacts_controller.dart';
import 'package:whatsapp_clone/feature/contacts/widgets/contact_card.dart';

class ContactPage extends ConsumerWidget {
  const ContactPage({super.key});

  shareSmsLink(phoneNumber) async {
    Uri sms = Uri.parse(
      "sms:${phoneNumber}?body=Let's chat on WhatsappX! It's a fast, simple and secure app where we can call each other for free. Get it at https://github.com/jaytomarr/whatsapp_clone",
    );
    if (await launchUrl(sms)) {
    } else {}
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Select contact', style: TextStyle(color: Colors.white)),
            SizedBox(height: 2),
            ref
                .watch(contactsControllerProvider)
                .when(
                  data: (allContacts) {
                    return Text(
                      '${allContacts[0].length} Contact${allContacts[0].length == 1 ? '' : 's'}',
                      style: TextStyle(fontSize: 12),
                    );
                  },
                  error: (error, stackTrace) {
                    return SizedBox();
                  },
                  loading: () {
                    return Text('counting...', style: TextStyle(fontSize: 12));
                  },
                ),
          ],
        ),
        actions: [
          CustomIconButton(onTap: () {}, icon: Icons.search_rounded),
          CustomIconButton(
            onTap: () {
              ref
                  .watch(contactsControllerProvider)
                  .when(
                    data: (allContacts) {
                      print(allContacts.length);
                      print(allContacts[0].length);
                      print(allContacts[1].length);
                      UserModel a = allContacts[1][0];
                      print(a.phoneNumber);
                    },
                    error: (error, stackTrace) {
                      return SizedBox();
                    },
                    loading: () {
                      return Text(
                        'counting...',
                        style: TextStyle(fontSize: 12),
                      );
                    },
                  );
            },
            icon: Icons.more_vert,
          ),
        ],
      ),
      body: ref
          .watch(contactsControllerProvider)
          .when(
            data: (allContacts) {
              return ListView.builder(
                itemCount: allContacts[0].length + allContacts[1].length,
                itemBuilder: (context, index) {
                  late UserModel firebaseContacts;
                  late UserModel phoneContacts;
                  if (index < allContacts[0].length) {
                    firebaseContacts = allContacts[0][index];
                  } else {
                    phoneContacts =
                        allContacts[1][index - allContacts[0].length];
                  }
                  return index < allContacts[0].length
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (index == 0)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  myListTile(
                                    leading: Icons.contacts,
                                    title: 'New Contact',
                                    trailing: Icons.qr_code,
                                  ),
                                  myListTile(
                                    leading: Icons.group,
                                    title: 'New Group',
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 10,
                                    ),
                                    child: Text(
                                      'Contacts on WhatsappX',
                                      style: TextStyle(
                                        color: context.theme.greyColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ContactCard(
                              contactsSource: firebaseContacts,
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  Routes.chat,
                                  arguments: firebaseContacts,
                                );
                              },
                            ),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (index == allContacts[0].length)
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                child: Text(
                                  'Contacts on your phone',
                                  style: TextStyle(
                                    color: context.theme.greyColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ContactCard(
                              contactsSource: phoneContacts,
                              onTap: () =>
                                  shareSmsLink(phoneContacts.phoneNumber),
                            ),
                          ],
                        );
                },
              );
            },
            error: (error, trace) {
              return null;
            },
            loading: () {
              return CircularProgressIndicator(
                color: context.theme.authAppBarTextColor,
              );
            },
          ),
    );
  }
}

ListTile myListTile({
  required IconData leading,
  required String title,
  IconData? trailing,
}) {
  return ListTile(
    contentPadding: EdgeInsets.only(top: 10, right: 10, left: 20),
    leading: CircleAvatar(
      radius: 20,
      backgroundColor: greenDark,
      child: Icon(leading, color: Colors.white),
    ),
    title: Text(
      title,
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
    ),
    trailing: Icon(trailing, color: greyDark),
  );
}
