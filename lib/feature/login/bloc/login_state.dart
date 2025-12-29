part of 'login_bloc.dart';

sealed class LoginState {}

class InitialState extends LoginState {}

class LoadingState extends LoginState {}

class LoadedState extends LoginState {}

class ErrorState extends LoginState {
  final String message;
  ErrorState({required this.message});
}