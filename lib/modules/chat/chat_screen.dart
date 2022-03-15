import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Chat Screen',
        style: Theme.of(context).textTheme.bodyText1,
      ),
    );
  }
}