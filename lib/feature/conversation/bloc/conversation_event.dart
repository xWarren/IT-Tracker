part of 'conversation_bloc.dart';

sealed class ConversationEvent {}

class LoadConversationEvent extends ConversationEvent {}

class SendTextMessageEvent extends ConversationEvent {
  final String text;
  SendTextMessageEvent(this.text);
}

class SendAudioMessageEvent extends ConversationEvent {
  final File audioFile;
  SendAudioMessageEvent(this.audioFile);
}

class IncomingMessageEvent extends ConversationEvent {
  final ConversationMessageEntity message;
  IncomingMessageEvent(this.message);
}

