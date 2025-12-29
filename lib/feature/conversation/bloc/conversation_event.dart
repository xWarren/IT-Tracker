part of 'conversation_bloc.dart';

sealed class ConversationEvent {}

class DoGetConversationEvent extends ConversationEvent {
  final String chatId;
  final String profilePicture;
  final String name;
  final String phoneNumber;
  DoGetConversationEvent({
    required this.chatId,
    required this.profilePicture,
    required this.name,
    required this.phoneNumber
  });
}