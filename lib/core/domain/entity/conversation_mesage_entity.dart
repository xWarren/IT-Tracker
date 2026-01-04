import '../../utils/enum/message_type_enum.dart';

class ConversationMessageEntity {
  final String id;
  final String senderId;
  final String receiverId;
  final bool isMe;
  final MessageTypeEnum type;
  final String? text;
  final String? filePath;
  final DateTime createdAt;

  ConversationMessageEntity({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.isMe,
    required this.type,
    this.text,
    this.filePath,
    required this.createdAt,
  });
}