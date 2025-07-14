import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_clone/common/extension/custom_theme_extension.dart';
import 'package:whatsapp_clone/common/models/last_message_model.dart';
import 'package:whatsapp_clone/common/models/user_model.dart';
import 'package:whatsapp_clone/common/routes/routes.dart';
import 'package:whatsapp_clone/common/utils/colors.dart';
import 'package:whatsapp_clone/feature/chat/controllers/chat_controller.dart';

class ChatsHomePage extends ConsumerWidget {
  const ChatsHomePage({super.key});

  navigateToContactsPage(context) {
    Navigator.pushNamed(context, Routes.contacts);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: StreamBuilder<List<LastMessageModel>>(
        stream: ref.watch(chatControllerProvider).getAllLastMessageList(),
        builder: (_, snapshot) {
          print(
            '📦 Snapshot: ${snapshot.connectionState}, hasData: ${snapshot.hasData}',
          );
          print('📦 Snapshot data: ${snapshot.data}');

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: greenDark));
          }

          final lastMessages = snapshot.data;

          if (lastMessages == null || lastMessages.isEmpty) {
            return Center(
              child: TextButton(
                onPressed: () {
                  print(snapshot.data);
                },
                child: Text("No chats yet"),
              ),
            );
          }
          return ListView.builder(
            itemCount: lastMessages.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final lastMessageData = lastMessages[index];
              return ListTile(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    Routes.chat,
                    arguments: UserModel(
                      username: lastMessageData.username,
                      uid: lastMessageData.contactId,
                      profileImageUrl: lastMessageData.profileImageUrl,
                      active: true,
                      lastSeen: 0,
                      phoneNumber: '0',
                      groupId: [],
                    ),
                  );
                },
                leading: CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(
                    lastMessageData.profileImageUrl,
                  ),
                  radius: 24,
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(lastMessageData.username, style: TextStyle()),
                    Text(
                      DateFormat.Hm().format(lastMessageData.timeSent),
                      style: TextStyle(
                        fontSize: 13,
                        color: context.theme.greyColor,
                      ),
                    ),
                  ],
                ),
                subtitle: Text(
                  lastMessageData.lastMessage,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: context.theme.greyColor),
                ),
              );
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => navigateToContactsPage(context),
        child: Icon(Icons.chat),
      ),
    );
  }
}
