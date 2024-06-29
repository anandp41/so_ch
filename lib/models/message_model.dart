import 'dart:convert';

import 'package:hive/hive.dart';

part 'message_model.g.dart';

@HiveType(typeId: 0)
class MessageModel extends HiveObject {
  @HiveField(0)
  final String text;

  @HiveField(1)
  final DateTime time;

  @HiveField(2)
  final String senderEmail;
  @HiveField(3)
  final String receiverEmail;
  MessageModel({
    required this.receiverEmail,
    required this.text,
    required this.time,
    required this.senderEmail,
  });

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'time': time.millisecondsSinceEpoch,
      'senderEmail': senderEmail,
      'receiverEmail': receiverEmail,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      text: map['text'] ?? '',
      time: DateTime.fromMillisecondsSinceEpoch(map['time']),
      senderEmail: map['senderEmail'] ?? '',
      receiverEmail: map['receiverEmail'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory MessageModel.fromJson(String source) =>
      MessageModel.fromMap(json.decode(source));
}
