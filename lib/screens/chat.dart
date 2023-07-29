import 'package:chat_app/widgets/chats_message.dart';
import 'package:chat_app/widgets/new_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Owl Chats'),
          actions: [
            IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              icon: const Icon(Icons.logout),
              color: Theme.of(context).colorScheme.primary,
            ),
          ],
        ),
        body: const Column(
          children: [
            Expanded(child: ChatMessages()),
            NewMessage(),
          ],
        ));
  }
}
