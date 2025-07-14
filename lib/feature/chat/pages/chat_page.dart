import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_clippers/custom_clippers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import 'package:whatsapp_clone/common/extension/custom_theme_extension.dart';
import 'package:whatsapp_clone/common/helper/show_last_seen.dart';
import 'package:whatsapp_clone/common/models/user_model.dart';
import 'package:whatsapp_clone/common/routes/routes.dart';
import 'package:whatsapp_clone/common/widgets/custom_icon_button.dart';
import 'package:whatsapp_clone/feature/auth/controller/auth_controller.dart';
import 'package:whatsapp_clone/feature/chat/controllers/chat_controller.dart';
import 'package:whatsapp_clone/feature/chat/widgets/chat_text_field.dart';
import 'package:whatsapp_clone/feature/chat/widgets/message_card.dart';
import 'package:whatsapp_clone/feature/chat/widgets/show_date_card.dart';
import 'package:whatsapp_clone/feature/chat/widgets/yellow_card.dart';

final pageStorageBucket = PageStorageBucket();

class ChatPage extends ConsumerWidget {
  ChatPage({super.key, required this.user});

  final UserModel user;
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: context.theme.chatPageBgColor,
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Row(
            children: [
              Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
              Hero(
                tag: 'profile',
                child: Container(
                  width: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(user.profileImageUrl),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        title: InkWell(
          onTap: () =>
              Navigator.pushNamed(context, Routes.profile, arguments: user),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: Column(
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
                      return Text(
                        'Not connected',
                        style: TextStyle(fontSize: 12),
                      );
                    }
                    final singleUserModel = snapshot.data!;
                    final lastMessage = lastSeenMessage(
                      singleUserModel.lastSeen,
                    );
                    return Text(
                      singleUserModel.active
                          ? 'Online'
                          : 'last seen $lastMessage ago',
                      style: TextStyle(fontSize: 12),
                    );
                  },
                ),
              ],
            ),
          ),
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
      body: Stack(
        children: [
          Image(
            image: AssetImage('assets/images/doodle_bg.png'),
            height: double.maxFinite,
            width: double.maxFinite,
            fit: BoxFit.cover,
            color: context.theme.chatPageDoodleColor,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 60),
            child: StreamBuilder(
              stream: ref
                  .watch(chatControllerProvider)
                  .getAllOneToOneMessage(user.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.active) {
                  return ListView.builder(
                    itemCount: 15,
                    itemBuilder: (_, index) {
                      final random = Random().nextInt(14);
                      return Container(
                        alignment: random.isEven
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        margin: EdgeInsets.only(
                          top: 5,
                          bottom: 5,
                          left: random.isEven ? 150 : 15,
                          right: random.isEven ? 15 : 150,
                        ),
                        child: ClipPath(
                          clipper: UpperNipMessageClipperTwo(
                            random.isEven
                                ? MessageType.send
                                : MessageType.receive,
                            nipWidth: 8,
                            nipHeight: 10,
                            bubbleRadius: 12,
                          ),
                          child: Shimmer.fromColors(
                            child: Container(
                              height: 40,
                              width:
                                  170 + double.parse((random * 2).toString()),
                            ),
                            baseColor: random.isEven
                                ? context.theme.greyColor!.withValues(
                                    alpha: 0.3,
                                  )
                                : context.theme.greyColor!.withValues(
                                    alpha: 0.2,
                                  ),
                            highlightColor: random.isEven
                                ? context.theme.greyColor!.withValues(
                                    alpha: 0.4,
                                  )
                                : context.theme.greyColor!.withValues(
                                    alpha: 0.3,
                                  ),
                          ),
                        ),
                      );
                    },
                  );
                }

                return PageStorage(
                  bucket: pageStorageBucket,
                  child: ListView.builder(
                    key: PageStorageKey('chat_page_list'),
                    controller: scrollController,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (_, index) {
                      final message = snapshot.data![index];
                      final isSender =
                          message.senderId ==
                          FirebaseAuth.instance.currentUser!.uid;
                      final haveNip =
                          (index == 0) ||
                          (index == snapshot.data!.length - 1 &&
                              message.senderId !=
                                  snapshot.data![index - 1].senderId) ||
                          (message.senderId !=
                                  snapshot.data![index - 1].senderId &&
                              message.senderId ==
                                  snapshot.data![index + 1].senderId) ||
                          (message.senderId !=
                                  snapshot.data![index - 1].senderId &&
                              message.senderId !=
                                  snapshot.data![index + 1].senderId);
                      final isShowDateCard =
                          (index == 0) ||
                          ((index == snapshot.data!.length - 1) &&
                              (message.timeSent.day >
                                  snapshot.data![index - 1].timeSent.day)) ||
                          (message.timeSent.day >
                                  snapshot.data![index - 1].timeSent.day &&
                              message.timeSent.day <=
                                  snapshot.data![index + 1].timeSent.day);
                      return Column(
                        children: [
                          if (index == 0) YellowCard(),
                          if (isShowDateCard)
                            ShowDateCard(date: message.timeSent),
                          MessageCard(
                            isSender: isSender,
                            haveNip: haveNip,
                            message: message,
                          ),
                        ],
                      );
                    },
                  ),
                );
              },
            ),
          ),
          Container(
            alignment: Alignment(0, 1),
            child: ChatTextField(
              receiverId: user.uid,
              scrollController: scrollController,
            ),
          ),
        ],
      ),
    );
  }
}
