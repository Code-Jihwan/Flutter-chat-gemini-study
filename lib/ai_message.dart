import 'package:flutter/material.dart';
import 'package:flutter_prj/chat_message.dart';

class AIMessage extends StatelessWidget {
  const AIMessage({
    super.key,
    required this.message,
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset('assets/images/ai.png'),
        const SizedBox(width: 16),
        ChatMessage(
          isHuman: false,
          message: message,
        ),
      ],
    );
  }
}
