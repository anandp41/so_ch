import 'package:flutter/material.dart';
import '../../../../../core/colors.dart';
import '../widgets/chat_box.dart';

class WebLayout extends StatelessWidget {
  const WebLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSecondaryColor,
      body: ChatBox(),
    );
  }
}
