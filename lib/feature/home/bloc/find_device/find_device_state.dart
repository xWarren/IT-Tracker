part of 'find_device_bloc.dart';

sealed class FindDeviceState {}

class InitialState extends FindDeviceState {}

class LoadingState extends FindDeviceState {}

class LoadedState extends FindDeviceState {}

class ErrorState extends FindDeviceState { 
  final String message;
  ErrorState({required this.message});
}