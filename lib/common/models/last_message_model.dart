import 'package:cloud_firestore/cloud_firestore.dart';

class LastMessageModel {
  final String username;
  final String profileImageUrl;
  final String contactId;
  final DateTime timeSent;
  final String lastMessage;

  LastMessageModel({
    required this.username,
    required this.profileImageUrl,
    required this.contactId,
    required this.timeSent,
    required this.lastMessage,
  });

  factory LastMessageModel.fromMap(Map<String, dynamic> map) {
    return LastMessageModel(
      username: map['username'] ?? '',
      profileImageUrl: map['profileImageUrl'] ?? '',
      contactId: map['contactId'] ?? '',
      // timeSent: DateTime.fromMillisecondsSinceEpoch(map['timeSent']),
      timeSent: map['timeSent'] is Timestamp
          ? (map['timeSent'] as Timestamp).toDate()
          : DateTime.parse(map['timeSent']),
      lastMessage: map['lastMessage'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'profileImageUrl': profileImageUrl,
      'contactId': contactId,
      // 'timeSent': timeSent.toIso8601String(),
      'timeSent': Timestamp.fromDate(timeSent),
      'lastMessage': lastMessage,
    };
  }
}
