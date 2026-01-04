part of 'connected_device_bloc.dart';

sealed class ConnectedDeviceState {}

class InitialState extends ConnectedDeviceState {}

class LoadingState extends ConnectedDeviceState {}

class LoadedState extends ConnectedDeviceState {
  final double distance;
  final String id;
  final String deviceName;
  LoadedState({
    required this.distance,
    required this.id,
    required this.deviceName,
  });
}

class ErrorState extends ConnectedDeviceState {
  final String message;
  ErrorState({required this.message});
}
