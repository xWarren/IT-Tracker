part of 'conversation_bloc.dart';

sealed class ConversationState {}

class ConversationInitial extends ConversationState {}

class ConversationLoaded extends ConversationState {
  final List<ConversationMessageEntity> messages;

  ConversationLoaded(this.messages);
}
