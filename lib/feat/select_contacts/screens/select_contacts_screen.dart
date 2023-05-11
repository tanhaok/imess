import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imess/common/widgets/error.dart';
import 'package:imess/common/widgets/loader.dart';
import 'package:imess/common/widgets/text_field.dart';
import 'package:imess/feat/chat/screens/mobile_chat_screen.dart';
import 'package:imess/feat/select_contacts/controller/select_contact_controller.dart';

class SelectContactsScreen extends ConsumerWidget {
  static const String routeName = '/select-contact';
  const SelectContactsScreen({Key? key}) : super(key: key);



  void searchByUsername() {}

  void selectUser(WidgetRef ref, Map<String, String> selectedContact,
      BuildContext context) {
    Navigator.pushNamed(
      context,
      MobileChatScreen.routeName,
      arguments: {
        'name': selectedContact["username"],
        'uid': selectedContact["uid"],
        'profilePic': selectedContact["photoUrl"],
        "isGroupChat": false
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: TextFieldInput(
          hintText: 'Search here...',
          textInputType: TextInputType.text,
          textEditingController: searchController,
        ),
        actions: [
          IconButton(
            onPressed: () {
              searchByUsername();
            },
            icon: const Icon(
              Icons.search,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.more_vert,
            ),
          ),
        ],
      ),
      body: ref.watch(getUserProvider).when(
            data: (contactList) => ListView.builder(
                itemCount: contactList.length,
                itemBuilder: (context, index) {
                  final contact = contactList[index];
                  return InkWell(
                    onTap: () => selectUser(ref, contact, context),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: ListTile(
                        title: Text(
                          contact["username"]!,
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        leading: contact["photoUrl"] == null
                            ? null
                            : CircleAvatar(
                                backgroundImage:
                                    NetworkImage(contact["photoUrl"]!),
                                radius: 30,
                              ),
                      ),
                    ),
                  );
                }),
            error: (err, trace) => ErrorScreen(error: err.toString()),
            loading: () => const Loader(),
          ),
    );
  }
}
