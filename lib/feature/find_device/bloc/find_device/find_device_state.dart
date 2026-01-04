part of 'find_device_bloc.dart';

sealed class FindDeviceState {}

class InitialState extends FindDeviceState {}

class InitializingState extends FindDeviceState {}

class InitializedState extends FindDeviceState {}

class ScanningState extends FindDeviceState {}

class ConnectingState extends FindDeviceState {
  final nearby.NearbyDevice device;
  ConnectingState(this.device);
}

class ConnectedState extends FindDeviceState {
  final nearby.NearbyDevice device;
  ConnectedState(this.device);
}

class ScanResultState extends FindDeviceState {
  final List<nearby.NearbyDevice> peers;
  ScanResultState(this.peers);
}

class ErrorState extends FindDeviceState {
  final String message;
  ErrorState(this.message);
}
