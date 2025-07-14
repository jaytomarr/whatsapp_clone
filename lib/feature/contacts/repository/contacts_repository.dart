import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/common/models/user_model.dart';

final contactsRepositoryProvider = Provider((ref) {
  return ContactsRepository(firestore: FirebaseFirestore.instance);
});

class ContactsRepository {
  final FirebaseFirestore firestore;

  ContactsRepository({required this.firestore});

  Future<List<List<UserModel>>> getAllContacts() async {
    //conatacts saved in the user's phone and have a account
    List<UserModel> firebaseContacts = [];
    //conatacts saved in the user's phone and doesn't have a account
    List<UserModel> phoneContacts = [];

    try {
      if (await FlutterContacts.requestPermission()) {
        final userCollection = await firestore.collection('users').get();
        final allContactsInThePhone = await FlutterContacts.getContacts(
          withProperties: true,
        );
        String normalizePhone(String phone) {
          return phone.replaceAll(
            RegExp(r'[^\d+]'),
            '',
          ); // removes everything except digits
        }

        bool isContactFound = false;
        for (var contact in allContactsInThePhone) {
          for (var firebaseContactData in userCollection.docs) {
            var firebaseContact = UserModel.fromMap(firebaseContactData.data());
            if (normalizePhone(contact.phones[0].number) ==
                firebaseContact.phoneNumber) {
              firebaseContacts.add(firebaseContact);
              isContactFound = true;
              break;
            }
          }
          if (!isContactFound) {
            phoneContacts.add(
              UserModel(
                username: contact.displayName,
                uid: '',
                profileImageUrl: '',
                active: false,
                lastSeen: 0,
                phoneNumber: normalizePhone(contact.phones[0].number),
                groupId: [],
              ),
            );
          }
          isContactFound = false;
        }
      }
    } catch (e) {
      log(e.toString());
    }
    return [firebaseContacts, phoneContacts];
  }
}
