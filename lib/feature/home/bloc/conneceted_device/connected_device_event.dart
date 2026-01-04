part of 'connected_device_bloc.dart';

sealed class ConnectedDeviceEvent {}

class DoConnectedEvent extends ConnectedDeviceEvent {}

class IsConnectedEvent extends ConnectedDeviceEvent {}

class DoDisconnectEvent extends ConnectedDeviceEvent {}

class UpdateRssiEvent extends ConnectedDeviceEvent {
  final int rssi;
  UpdateRssiEvent({required this.rssi});
}
