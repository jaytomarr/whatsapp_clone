import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/common/models/user_model.dart';
import 'package:whatsapp_clone/common/widgets/custom_icon_button.dart';
import 'package:whatsapp_clone/feature/auth/controller/auth_controller.dart';

class ChatPage extends ConsumerWidget {
  const ChatPage({super.key, required this.user});

  final UserModel user;

  String lastSeenMessage(lastSeen) {
    DateTime now = DateTime.now();
    Duration differenceDuration = now.difference(
      DateTime.fromMillisecondsSinceEpoch(lastSeen),
    );

    String finalMessage = differenceDuration.inSeconds > 59
        ? differenceDuration.inMinutes > 59
              ? differenceDuration.inHours > 23
                    ? "${differenceDuration.inDays} ${differenceDuration.inDays == 1 ? 'day' : 'days'}"
                    : "${differenceDuration.inHours} ${differenceDuration.inHours == 1 ? 'hour' : 'hours'}"
              : "${differenceDuration.inMinutes} ${differenceDuration.inMinutes == 1 ? 'minute' : 'minutes'}"
        : 'few moments ago';

    return finalMessage;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Row(
            children: [
              Icon(Icons.arrow_back_ios_rounded),
              SizedBox(width: 4),
              CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage(user.profileImageUrl),
              ),
            ],
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user.username,
              style: TextStyle(
                // fontSize: 18,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 2),
            StreamBuilder(
              stream: ref
                  .read(authControllerProvider)
                  .getuserPresenceStatus(uid: user.uid),
              builder: (_, snapshot) {
                if (snapshot.connectionState != ConnectionState.active) {
                  return Text('Not connected', style: TextStyle(fontSize: 12));
                }

                final singleUserModel = snapshot.data!;

                final lastMessage = lastSeenMessage(singleUserModel.lastSeen);

                return Text(
                  singleUserModel.active ? 'Online' : '$lastMessage ago',
                  style: TextStyle(fontSize: 12),
                );
              },
            ),
          ],
        ),
        actions: [
          CustomIconButton(
            onTap: () {},
            icon: Icons.video_call_rounded,
            iconColor: Colors.white,
          ),
          CustomIconButton(
            onTap: () {},
            icon: Icons.call,
            iconColor: Colors.white,
          ),
          CustomIconButton(
            onTap: () {},
            icon: Icons.more_vert,
            iconColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
