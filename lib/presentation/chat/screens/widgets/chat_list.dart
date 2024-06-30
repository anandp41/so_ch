import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/border_radius.dart';
import '../../../../core/textstyles.dart';

import '../../../../core/colors.dart';
import '../../../../core/strings.dart';
import '../../bloc/web_socket_bloc.dart';
import 'functions.dart';
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
            return const Text(
              messageToDisplayIfChatIsEmpty,
              style: myMessageCardTextstyle,
            );
          } else {
            String? date = '';
            return ListView.builder(
              controller: scrollController,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                bool printDate = false;
                String newDate = groupMessageDateAndTime(state
                        .messages[index].time.microsecondsSinceEpoch
                        .toString())
                    .toString();
                if (date != newDate) {
                  date = newDate;
                  printDate = true;
                }
                return Column(
                  children: [
                    if (printDate)
                      Center(
                          child: Container(
                              decoration: BoxDecoration(
                                  color: chatScreenDateBg,
                                  borderRadius:
                                      BorderRadius.circular(borderRadius)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  newDate,
                                  style: chatDateTextStyle,
                                ),
                              ))),
                    if (messages[index]['isMe'] == true)
                      MyMessageCard(
                        message: messages[index]['text'].toString(),
                        date: messages[index]['time'].toString(),
                      )
                    else
                      SenderMessageCard(
                        message: messages[index]['text'].toString(),
                        date: messages[index]['time'].toString(),
                      )
                  ],
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
