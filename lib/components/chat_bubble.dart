import 'package:chat_app/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    required this.message,
    required this.isCurrentUser,
    required this.timestamp,
  });

  final String message;
  final bool isCurrentUser;
  final Timestamp timestamp;

  @override
  Widget build(BuildContext context) {
    // light vs dark mode for correct bubble colors
    bool isDarkMode =
        Provider.of<ThemeProvider>(context, listen: false).isDarkMode;

    // Convert Timestamp to a readable time format
    String timeSent = DateFormat('h:mm a').format(timestamp.toDate());

    return Container(
      decoration: BoxDecoration(
        color: isCurrentUser
            ? (isDarkMode ? Colors.green.shade600 : Colors.green.shade500)
            : (isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 8),
      margin: const EdgeInsets.symmetric(vertical: 2.5, horizontal: 25),
      child: IntrinsicWidth(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message,
              style: TextStyle(
                fontSize: 16,
                color: isCurrentUser
                    ? Colors.white
                    : (isDarkMode ? Colors.white : Colors.black),
              ),
            ),
            const SizedBox(height: 8), // Space between message and time
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                timeSent,
                style: TextStyle(
                  color: isCurrentUser
                      ? Colors.white.withOpacity(0.7)
                      : (isDarkMode
                          ? Colors.white.withOpacity(0.7)
                          : Colors.black.withOpacity(0.7)),
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
