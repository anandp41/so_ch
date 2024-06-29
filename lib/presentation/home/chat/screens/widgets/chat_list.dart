import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../core/colors.dart';
import '../../bloc/web_socket_bloc.dart';
import 'my_message_card.dart';
import 'sender_message_card.dart';

class ChatList extends StatelessWidget {
  ChatList({Key? key}) : super(key: key);

  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WebSocketBloc, WebSocketState>(
      builder: (context, state) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          if (scrollController.hasClients) {
            scrollController.animateTo(
              scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        });
        if (state is WebSocketMessageReceived) {
          final messages = state.messages.map((message) {
            return {
              'text': message.text,
              'time': DateFormat('hh:mm a').format(message.time),
              'isMe': message.senderEmail ==
                  context.read<WebSocketBloc>().loggedInEmail,
            };
          }).toList();
          if (messages.isEmpty) {
            return const Text("Send a message to get an echo from the server");
          } else {
            return ListView.builder(
              controller: scrollController,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                if (messages[index]['isMe'] == true) {
                  return MyMessageCard(
                    message: messages[index]['text'].toString(),
                    date: messages[index]['time'].toString(),
                  );
                }
                return SenderMessageCard(
                  message: messages[index]['text'].toString(),
                  date: messages[index]['time'].toString(),
                );
              },
            );
          }
        }
        return const Center(
            child: CircularProgressIndicator(
          color: kPrimaryColor,
        ));
      },
    );
  }
}
