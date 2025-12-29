part of 'register_bloc.dart';

sealed class RegisterState {}

class InitialState extends RegisterState {}

class LoadingState extends RegisterState {}

class LoadedState extends RegisterState {}

class ErrorState extends RegisterState {
  final String message;
  ErrorState({required this.message});
}