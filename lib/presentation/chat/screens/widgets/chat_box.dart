import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/border_radius.dart';

import '../../../../core/colors.dart';
import '../../bloc/web_socket_bloc.dart';
import 'chat_list.dart';
import 'web_chat_appbar.dart';

class ChatBox extends StatelessWidget {
  ChatBox({
    super.key,
  });
  final messageController = TextEditingController();
  void sendMessage(BuildContext context) {
    context
        .read<WebSocketBloc>()
        .add(SendMessage(messageController.text.trim()));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: kSecondaryColor,
      ),
      child: Column(
        children: [
          const ChatAppBar(),
          const SizedBox(height: 20),
          Expanded(
            child: ChatList(),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.07,
            constraints: const BoxConstraints(minHeight: 50),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              border: const Border(
                bottom: BorderSide(color: dividerColor),
              ),
              color: kPrimaryColor,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 10,
                      top: 10,
                      bottom: 10,
                      right: 15,
                    ),
                    child: TextField(
                      style: const TextStyle(color: kPrimaryLightColor),
                      controller: messageController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: kSecondaryColor,
                        hintText: 'Type a message',
                        hintStyle: const TextStyle(color: hintTextColor),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: const BorderSide(
                            width: 0,
                            style: BorderStyle.none,
                          ),
                        ),
                        contentPadding: const EdgeInsets.only(left: 20),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (messageController.text.trim().isNotEmpty) {
                      sendMessage(context);
                      messageController.clear();
                    }
                  },
                  icon: const Icon(
                    Icons.send,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
