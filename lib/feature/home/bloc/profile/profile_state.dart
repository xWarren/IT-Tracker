part of 'profile_bloc.dart';

sealed class ProfileState {}

class InitialState extends ProfileState {}

class LoadingState extends ProfileState {}

class LoadedState extends ProfileState {}

class ErrorState extends ProfileState {
  final String message;
  ErrorState({required this.message});
}