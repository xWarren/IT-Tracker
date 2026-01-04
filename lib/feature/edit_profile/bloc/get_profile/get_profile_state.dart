part of 'get_profile_bloc.dart';

sealed class GetProfileState {}

class InitialState extends GetProfileState {}

class LoadingState extends GetProfileState {}

class LoadedState extends GetProfileState {
  final String file;
  final String name;
  final String phoneNumber;
  LoadedState({
    required this.file,
    required this.name,
    required this.phoneNumber
  });
}

class ErrorState extends GetProfileState {
  final String message;
  ErrorState(this.message);
}