import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_clippers/custom_clippers.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_clone/common/enum/message_type.dart' as MyMessagetype;
import 'package:whatsapp_clone/common/extension/custom_theme_extension.dart';
import 'package:whatsapp_clone/common/models/message_model.dart';

class MessageCard extends StatelessWidget {
  const MessageCard({
    super.key,
    required this.isSender,
    required this.haveNip,
    required this.message,
  });

  final bool isSender;
  final bool haveNip;
  final MessageModel message;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      margin: EdgeInsets.only(
        top: 4,
        bottom: 4,
        left: isSender
            ? 80
            : haveNip
            ? 10
            : 15,
        right: isSender
            ? haveNip
                  ? 15
                  : 10
            : 80,
      ),
      child: ClipPath(
        clipper: haveNip
            ? UpperNipMessageClipperTwo(
                isSender ? MessageType.send : MessageType.receive,
                nipWidth: 8,
                nipHeight: 10,
                bubbleRadius: haveNip ? 12 : 0,
              )
            : null,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: isSender
                    ? context.theme.senderChatCardBg
                    : context.theme.receiverChatCardBg,
                boxShadow: [BoxShadow(color: Colors.black38)],
                borderRadius: haveNip ? null : BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: message.type == MyMessagetype.MessageType.image
                    ? Padding(
                        padding: const EdgeInsets.only(
                          top: 3,
                          left: 3,
                          right: 3,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image(
                            image: CachedNetworkImageProvider(
                              message.textMessage,
                            ),
                          ),
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.only(
                          top: 8,
                          bottom: 8,
                          left: isSender ? 10 : 15,
                          right: isSender ? 15 : 10,
                        ),
                        child: Text(
                          "${message.textMessage}         ",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
              ),
            ),
            Positioned(
              bottom: message.type == MyMessagetype.MessageType.text ? 8 : 4,
              right: message.type == MyMessagetype.MessageType.text
                  ? isSender
                        ? 15
                        : 10
                  : 4,
              child: message.type == MyMessagetype.MessageType.text
                  ? Text(
                      DateFormat.Hm().format(message.timeSent),
                      style: TextStyle(
                        fontSize: 11,
                        color: context.theme.greyColor,
                      ),
                    )
                  : Container(
                      padding: EdgeInsets.only(
                        left: 20,
                        top: 10,
                        right: 10,
                        bottom: 10,
                      ),
                      child: Text(
                        DateFormat.Hm().format(message.timeSent),
                        style: TextStyle(
                          fontSize: 11,
                          color: context.theme.greyColor,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
