part of 'find_device_bloc.dart';

sealed class FindDeviceEvent {}

class InitializeNearbyEvent extends FindDeviceEvent {}

class StartDiscoverEvent extends FindDeviceEvent {}

class StopDiscoverEvent extends FindDeviceEvent {}

class DoConnectEvent extends FindDeviceEvent {
  final nearby.NearbyDevice device;
  DoConnectEvent(this.device);
}

class _PeersUpdatedEvent extends FindDeviceEvent {
  final List<nearby.NearbyDevice> peers;
  _PeersUpdatedEvent(this.peers);
}