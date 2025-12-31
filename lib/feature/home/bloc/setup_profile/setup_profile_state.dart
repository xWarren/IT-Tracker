part of 'setup_profile_bloc.dart';

sealed class SetupProfileState {}

class InitialState extends SetupProfileState {}

class LoadingState extends SetupProfileState {}

class LoadedState extends SetupProfileState {}

class ErrorState extends SetupProfileState {
  final String message;
  ErrorState({required this.message});
}