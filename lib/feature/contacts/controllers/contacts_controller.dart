import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/feature/contacts/repository/contacts_repository.dart';

final contactsControllerProvider = FutureProvider((ref) {
  final contactsRepository = ref.watch(contactsRepositoryProvider);
  return contactsRepository.getAllContacts();
});
