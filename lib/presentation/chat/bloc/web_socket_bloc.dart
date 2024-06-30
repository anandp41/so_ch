import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../core/strings.dart';
import '../../../models/message_model.dart';
import '../../auth/bloc/authentication_bloc.dart';

part 'web_socket_event.dart';
part 'web_socket_state.dart';

class WebSocketBloc extends Bloc<WebSocketEvent, WebSocketState> {
  final WebSocketChannel channel;
  late StreamSubscription _subscription;
  final Box<MessageModel> _messageBox;
  final String loggedInEmail;
  WebSocketBloc({required this.channel, required this.loggedInEmail})
      : _messageBox = Hive.box<MessageModel>(hiveMessagesBox),
        super(WebSocketInitial()) {
    on<InitializeMessages>(_onInitializeMessages);
    on<SendMessage>(_onSendMessage);
    on<ReceiveMessage>(_onReceiveMessage);

    // Emit initial state with stored messages
    add(InitializeMessages());

    _subscription = channel.stream.listen((data) {
      add(ReceiveMessage(data));
    });
  }

  void _onInitializeMessages(
      InitializeMessages event, Emitter<WebSocketState> emit) {
    emit(WebSocketMessageReceived(
        messages: chatMessagesInvolvingLoggedInUser(
            messagesInHive: _messageBox.values.toList(),
            loggedInEmail: loggedInEmail)));
  }

  Future<void> _onSendMessage(
      SendMessage event, Emitter<WebSocketState> emit) async {
    var message = MessageModel(
        receiverEmail: server,
        senderEmail: loggedInEmail,
        text: event.text,
        time: DateTime.now());

    channel.sink.add(message.toJson());
    await _messageBox.add(message);
    emit(WebSocketMessageReceived(
        messages: chatMessagesInvolvingLoggedInUser(
            messagesInHive: _messageBox.values.toList(),
            loggedInEmail: loggedInEmail)));
  }

  Future<void> _onReceiveMessage(
      ReceiveMessage event, Emitter<WebSocketState> emit) async {
    if (event.message.startsWith('{')) {
      var message = MessageModel.fromJson(event.message);
      var newMessage = MessageModel(
          // Since this is an echo, the sender and receiver is reversed.
          receiverEmail: message.senderEmail,
          text: message.text,
          time: DateTime.now(),
          senderEmail: message.receiverEmail);

      await _messageBox.add(newMessage);
      emit(WebSocketMessageReceived(
          messages: chatMessagesInvolvingLoggedInUser(
              messagesInHive: _messageBox.values.toList(),
              loggedInEmail: loggedInEmail)));
    }
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    channel.sink.close();
    return super.close();
  }
}

List<MessageModel> chatMessagesInvolvingLoggedInUser(
    {required List<MessageModel> messagesInHive,
    required String loggedInEmail}) {
  log("Works");
  log(messagesInHive.length.toString());
  List<MessageModel> result = [];
  for (var eachMessage in messagesInHive) {
    log("LogEmail: $loggedInEmail| Receiver:${eachMessage.receiverEmail} | Sender: ${eachMessage.senderEmail}|Message: ${eachMessage.text}");
    if (eachMessage.senderEmail == loggedInEmail ||
        eachMessage.receiverEmail == loggedInEmail) {
      result.add(eachMessage);
    }
  }

  return result;
}
