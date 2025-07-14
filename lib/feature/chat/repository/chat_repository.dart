import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/common/enum/message_type.dart';
import 'package:whatsapp_clone/common/helper/show_alert_dilaog.dart';
import 'package:whatsapp_clone/common/models/last_message_model.dart';
import 'package:whatsapp_clone/common/models/message_model.dart';
import 'package:whatsapp_clone/common/models/user_model.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_clone/common/repository/firebase_storage_repository.dart';

final chatRepositoryProvider = Provider((ref) {
  return ChatRepository(
    auth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
  );
});

class ChatRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  ChatRepository({required this.auth, required this.firestore});

  void sendFileMessage({
    required var file,
    required BuildContext context,
    required String receiverId,
    required UserModel senderData,
    required Ref ref,
    required MessageType messageType,
  }) async {
    try {
      final timeSent = DateTime.now();
      final messageId = Uuid().v1();
      final imageUrl = await ref
          .read(firebaseStorageRepositoryProvider)
          .storeFileToFirebase(
            'chats/${messageType.type}/${senderData.uid}/$receiverId/$messageId',
            file,
          );
      final userMap = await firestore.collection('users').doc(receiverId).get();
      final receiverUserData = UserModel.fromMap(userMap.data()!);

      String lastMessage;

      switch (messageType) {
        case MessageType.image:
          lastMessage = 'Photo message';
          break;
        case MessageType.audio:
          lastMessage = 'Voice message';
          break;
        case MessageType.video:
          lastMessage = 'Video message';
          break;
        case MessageType.gif:
          lastMessage = 'GIF message';
          break;
        default:
          lastMessage = 'GIF message';
          break;
      }

      saveToMessageCollection(
        receiverId: receiverId,
        textMessage: imageUrl,
        timeSent: timeSent,
        textMessageId: messageId,
        senderUsername: senderData.username,
        receiverUsername: receiverUserData.username,
        messageType: messageType,
      );

      saveAsLastMessage(
        senderUserData: senderData,
        receiverUserData: receiverUserData,
        lastMessage: lastMessage,
        timeSent: timeSent,
        receiverId: receiverId,
      );
    } catch (e) {
      showAlertDilaog(context: context, message: e.toString());
    }
  }

  Stream<List<MessageModel>> getAllOneToOneMessage(String receiverId) {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('timeSent')
        .snapshots()
        .map((event) {
          List<MessageModel> messages = [];
          for (var message in event.docs) {
            messages.add(MessageModel.fromMap(message.data()));
          }
          return messages;
        });
  }

  Stream<List<LastMessageModel>> getAllLastMessageList() {
    print('🔄 Listening for last message updates...');
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .snapshots()
        .asyncMap((event) async {
          print('📥 Received snapshot with ${event.docs.length} documents');

          try {
            final futures = event.docs.map((doc) async {
              final data = doc.data();
              print('📄 Raw doc data: $data');

              final lastMessage = LastMessageModel.fromMap(data);

              final userSnap = await firestore
                  .collection('users')
                  .doc(lastMessage.contactId)
                  .get();

              if (!userSnap.exists) {
                print('⚠️ User with id ${lastMessage.contactId} not found');
                return null; // Don't add this to list
              }

              final user = UserModel.fromMap(userSnap.data()!);

              return LastMessageModel(
                username: user.username,
                profileImageUrl: user.profileImageUrl,
                contactId: lastMessage.contactId,
                timeSent: lastMessage.timeSent,
                lastMessage: lastMessage.lastMessage,
              );
            }).toList();

            final contactsWithNulls = await Future.wait(futures);
            final contacts = contactsWithNulls
                .whereType<LastMessageModel>()
                .toList();
            print('✅ Returning ${contacts.length} contacts');

            return contacts;
          } catch (e, st) {
            print('❌ Error in asyncMap: $e');
            print(st);
            return []; // Return empty list instead of null
          }
          // List<LastMessageModel> contacts = [];
          // for (var document in event.docs) {
          //   final lastMessage = LastMessageModel.fromMap(document.data());
          //   print('➡️ Contact ID: ${lastMessage.contactId}');
          //   print('➡️ Last Message: ${lastMessage.lastMessage}');
          //   final userData = await firestore
          //       .collection('users')
          //       .doc(lastMessage.contactId)
          //       .get();
          //   final user = UserModel.fromMap(userData.data()!);
          //   contacts.add(
          //     LastMessageModel(
          //       username: user.username,
          //       profileImageUrl: user.profileImageUrl,
          //       contactId: lastMessage.contactId,
          //       timeSent: lastMessage.timeSent,
          //       lastMessage: lastMessage.lastMessage,
          //     ),
          //   );
          // }
          // print('✅ Returning ${contacts.length} contacts');
          // return contacts;
        });
  }

  void sendTextMessage({
    required BuildContext context,
    required String textMessage,
    required String receiverId,
    required UserModel senderData,
  }) async {
    try {
      final timeSent = DateTime.now();
      final receiverDataMap = await firestore
          .collection('users')
          .doc(receiverId)
          .get();
      final receiverData = UserModel.fromMap(receiverDataMap.data()!);
      final textMessageId = Uuid().v1();

      saveToMessageCollection(
        receiverId: receiverId,
        textMessage: textMessage,
        timeSent: timeSent,
        textMessageId: textMessageId,
        senderUsername: senderData.username,
        receiverUsername: receiverData.username,
        messageType: MessageType.text,
      );

      saveAsLastMessage(
        senderUserData: senderData,
        receiverUserData: receiverData,
        lastMessage: textMessage,
        timeSent: timeSent,
        receiverId: receiverId,
      );
    } catch (e) {
      showAlertDilaog(context: context, message: e.toString());
    }
  }

  void saveToMessageCollection({
    required String receiverId,
    required String textMessage,
    required DateTime timeSent,
    required String textMessageId,
    required String senderUsername,
    required String receiverUsername,
    required MessageType messageType,
  }) async {
    final message = MessageModel(
      senderId: auth.currentUser!.uid,
      receiverId: receiverId,
      textMessage: textMessage,
      type: messageType,
      timeSent: timeSent,
      messageId: textMessageId,
      isSeen: false,
    );

    // sender
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .doc(textMessageId)
        .set(message.toMap());

    // receiver
    await firestore
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(auth.currentUser!.uid)
        .collection('messages')
        .doc(textMessageId)
        .set(message.toMap());
  }

  void saveAsLastMessage({
    required UserModel senderUserData,
    required UserModel receiverUserData,
    required String lastMessage,
    required DateTime timeSent,
    required String receiverId,
  }) async {
    print('✅ saveAsLastMessage CALLED');
    print('Sender: ${auth.currentUser!.uid}');
    print('Receiver: $receiverId');
    print('Message: $lastMessage');

    final receiverLastMessage = LastMessageModel(
      username: senderUserData.username,
      profileImageUrl: senderUserData.profileImageUrl,
      contactId: senderUserData.uid,
      timeSent: timeSent,
      lastMessage: lastMessage,
    );

    await firestore
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(auth.currentUser!.uid)
        .set(receiverLastMessage.toMap());

    final senderLastMessage = LastMessageModel(
      username: receiverUserData.username,
      profileImageUrl: receiverUserData.profileImageUrl,
      contactId: receiverUserData.uid,
      timeSent: timeSent,
      lastMessage: lastMessage,
    );

    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(receiverId)
        .set(senderLastMessage.toMap());

    print('✅ saveAsLastMessage COMPLETED');
  }
}
