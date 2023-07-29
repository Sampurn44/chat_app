import 'package:chat_app/screens/chat.dart';
import 'package:chat_app/widgets/message_buble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key});
  @override
  Widget build(BuildContext context) {
    final authenticatesuser = FirebaseAuth.instance.currentUser!;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy(
            'createdat',
            descending: true,
          )
          .snapshots(),
      builder: (ctx, chatSnapshots) {
        if (chatSnapshots.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (!chatSnapshots.hasData || chatSnapshots.data!.docs.isEmpty) {
          return const Center(
            child: Text('No messages found'),
          );
        }
        if (chatSnapshots.hasError) {
          return const Center(
            child: Text('Error While Fetching Data'),
          );
        }
        final loadedmesssage = chatSnapshots.data!.docs;
        return ListView.builder(
          padding: const EdgeInsets.only(
            bottom: 40,
            left: 13,
            right: 13,
          ),
          reverse: true,
          itemCount: loadedmesssage.length,
          itemBuilder: (ctx, index) {
            final chatMessage = loadedmesssage[index].data();
            final nextchat = index + 1 < loadedmesssage.length
                ? loadedmesssage[index + 1].data()
                : null;
            final currentmessageuserId = chatMessage['Userid'];
            final nextmessageuserId =
                nextchat != null ? nextchat['Userid'] : null;
            final nextusersame = nextmessageuserId == currentmessageuserId;
            if (nextusersame) {
              return MessageBubble.next(
                message: chatMessage['text'],
                isMe: authenticatesuser.uid == currentmessageuserId,
              );
            } else {
              return MessageBubble.first(
                  userImage: chatMessage['userimage'],
                  username: chatMessage['username'],
                  message: chatMessage['text'],
                  isMe: authenticatesuser.uid == currentmessageuserId);
            }
          },
        );
      },
    );
  }
}
