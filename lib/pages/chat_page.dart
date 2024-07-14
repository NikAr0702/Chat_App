// // import 'dart:html';
// // import 'dart:js';

// import 'package:chat_app/components/chat_bubble.dart';
// import 'package:chat_app/components/my_textfield.dart';
// import 'package:chat_app/services/auth/auth_service.dart';
// import 'package:chat_app/services/chat/chat_services.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class ChatPage extends StatefulWidget {
//   ChatPage({super.key, required this.receiverEmail, required this.receiverID});

//   final String receiverEmail;
//   final String receiverID;

//   @override
//   State<ChatPage> createState() => _ChatPageState();
// }

// class _ChatPageState extends State<ChatPage> {
//   //text editing controller
//   final TextEditingController _messageController = TextEditingController();

//   //chat and auth services
//   final ChatService _chatService = ChatService();
//   final AuthService _authService = AuthService();

//   //for textfield focus

//   FocusNode myFocusNode = FocusNode();

//   void initState() {
//     super.initState();

//     // add listener to focus node
//     myFocusNode.addListener(() {
//       if (myFocusNode.hasFocus) {
//         //cause a delay so that the keyboard has time to show up
//         //then the amount of remaining space will be calculated
//         //then scroll down
//         Future.delayed(
//           const Duration(milliseconds: 500),
//           () => scrollDown(),
//         );
//       }
//     });

//     // wait a bit for listview to be built, then scroll to bottom

//     Future.delayed(Duration(milliseconds: 500), () => scrollDown());
//   }

//   @override
//   void dispose() {
//     myFocusNode.dispose();
//     _messageController.dispose();
//     super.dispose();
//   }

//   /// scroll controller
//   final ScrollController _scrollController = ScrollController();

//   void scrollDown() {
//     _scrollController.animateTo(
//       _scrollController.position.maxScrollExtent,
//       duration: const Duration(seconds: 1),
//       curve: Curves.fastOutSlowIn,
//     );
//   }

//   void sendMessage() async {
//     // if there is something inside the textfield
//     if (_messageController.text.isNotEmpty) {
//       //send message
//       await _chatService.sendMessage(
//           widget.receiverID, _messageController.text);

//       //clear the text controller
//       _messageController.clear();
//     }

//     scrollDown();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Theme.of(context).colorScheme.background,
//       appBar: AppBar(
//         title: Text(widget.receiverEmail),
//         backgroundColor: Colors.transparent,
//         foregroundColor: Colors.grey,
//       ),
//       body: Column(
//         children: [
//           //display all the messages

//           Expanded(child: _buildMessageList()),

//           //user input
//           _buildUserInput(),
//         ],
//       ),
//     );
//   }

//   //build message list
//   Widget _buildMessageList() {
//     String senderID = _authService.getCurrentUser()!.uid;
//     return StreamBuilder(
//       stream: _chatService.getMessages(widget.receiverID, senderID),
//       builder: (context, snapshot) {
//         //errors
//         if (snapshot.hasError) {
//           return const Text('Error');
//         }

//         //loading
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Text('Loading');
//         }
//         //return list view

//         return ListView(
//           controller: _scrollController,
//           children:
//               snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
//         );
//       },
//     );
//   }

//   // build message item
//   Widget _buildMessageItem(DocumentSnapshot doc) {
//     Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

//     //is current user

//     bool isCurrentUser = data['senderID'] == _authService.getCurrentUser()!.uid;

//     // align message to the right if sender is the current user, otherwise left
//     var alignment =
//         isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

//     return Container(
//         alignment: alignment,
//         child: Column(
//           crossAxisAlignment:
//               isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//           children: [
//             ChatBubble(
//               message: data['message'],
//               isCurrentUser: isCurrentUser,
//             ),
//           ],
//         ));
//   }

//   //build message input
//   Widget _buildUserInput() {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 25, top: ),
//       child: Row(
//         children: [
//           //Textfield should take up most of the space
//           Expanded(
//             child: MyTextField(
//               controller: _messageController,
//               hintText: 'Type a message',
//               obscureText: false,
//               focusNode: myFocusNode,
//             ),
//           ),

//           //send Button
//           Container(
//             decoration: BoxDecoration(
//               color: Colors.green,
//               shape: BoxShape.circle,
//             ),
//             margin: EdgeInsets.only(right: 25),
//             child: IconButton(
//               onPressed: sendMessage,
//               icon: const Icon(
//                 Icons.arrow_upward,
//                 color: Colors.white,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:chat_app/components/chat_bubble.dart';
import 'package:chat_app/components/my_textfield.dart';
import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/services/chat/chat_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  ChatPage({super.key, required this.receiverEmail, required this.receiverID});

  final String receiverEmail;
  final String receiverID;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();
  final ScrollController _scrollController = ScrollController();
  FocusNode myFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    myFocusNode.addListener(() {
      if (myFocusNode.hasFocus) {
        Future.delayed(
          const Duration(milliseconds: 500),
          () => scrollDown(),
        );
      }
    });

    Future.delayed(const Duration(milliseconds: 500), () => scrollDown());
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
        widget.receiverID,
        _messageController.text,
      );
      _messageController.clear();
    }
    scrollDown();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(widget.receiverEmail),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
      ),
      body: Column(
        children: [
          Expanded(child: _buildMessageList()),
          _buildUserInput(),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    String senderID = _authService.getCurrentUser()!.uid;
    return StreamBuilder(
      stream: _chatService.getMessages(widget.receiverID, senderID),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Error');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading');
        }

        return ListView(
          controller: _scrollController,
          children:
              snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
        );
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    bool isCurrentUser = data['senderID'] == _authService.getCurrentUser()!.uid;
    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Column(
        crossAxisAlignment:
            isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          ChatBubble(
            message: data['message'],
            isCurrentUser: isCurrentUser,
            timestamp: data['timestamp'], // Pass the timestamp here
          ),
        ],
      ),
    );
  }

  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25, top: 10),
      child: Row(
        children: [
          Expanded(
            child: MyTextField(
              controller: _messageController,
              hintText: 'Type a message',
              obscureText: false,
              focusNode: myFocusNode,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
            margin: const EdgeInsets.only(right: 25),
            child: IconButton(
              onPressed: sendMessage,
              icon: const Icon(
                Icons.arrow_upward,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
