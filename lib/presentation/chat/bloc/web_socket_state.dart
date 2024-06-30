part of 'web_socket_bloc.dart';

sealed class WebSocketState extends Equatable {
  const WebSocketState();

  @override
  List<Object> get props => [];
}

class WebSocketInitial extends WebSocketState {}

class WebSocketMessageReceived extends WebSocketState {
  final List<MessageModel> messages;

  const WebSocketMessageReceived({required this.messages});

  @override
  List<Object> get props => [messages];
}
