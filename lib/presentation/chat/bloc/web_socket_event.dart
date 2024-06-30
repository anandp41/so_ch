part of 'web_socket_bloc.dart';

sealed class WebSocketEvent extends Equatable {
  const WebSocketEvent();

  @override
  List<Object> get props => [];
}

class InitializeMessages extends WebSocketEvent {}

class SendMessage extends WebSocketEvent {
  final String text;

  const SendMessage(this.text);

  @override
  List<Object> get props => [text];
}

class ReceiveMessage extends WebSocketEvent {
  final String message;

  const ReceiveMessage(this.message);

  @override
  List<Object> get props => [message];
}
