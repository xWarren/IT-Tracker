part of 'set_profile_bloc.dart';

sealed class SetProfileState {}

class InitialState extends SetProfileState {}

class LoadingState extends SetProfileState {}

class LoadedState extends SetProfileState {}

class ErrorState extends SetProfileState {}