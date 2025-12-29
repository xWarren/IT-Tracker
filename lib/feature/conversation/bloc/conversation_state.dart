part of 'conversation_bloc.dart';

sealed class ConversationState {}

class InitialState extends ConversationState {}

class LoadingState extends ConversationState {}

class LoadedState extends ConversationState {}

class ErrorState extends ConversationState {
  final String message;
  ErrorState({required this.message});
}