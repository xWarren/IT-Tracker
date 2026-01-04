import 'dart:async';
import 'dart:developer' as dev;

import 'package:bloc/bloc.dart';

import '../../../../core/domain/service/nearby_service.dart';
import '../../../../di/_dependencies.dart';
import '../../../../di/shared_preferences_manager.dart';

part 'connected_device_event.dart';
part 'connected_device_state.dart';

class ConnectedDeviceBloc extends Bloc<ConnectedDeviceEvent, ConnectedDeviceState> {
  
  ConnectedDeviceBloc() : super(InitialState()) {
    on<DoConnectedEvent>(_doConnected);
    on<DoDisconnectEvent>(_doDisconnect);
    on<UpdateRssiEvent>(_updateRssi);
    on<IsConnectedEvent>(_isConnected);
  }

  final SharedPreferencesManager _sharedPreferencesManager = getIt();
  final NearbyService _nearbyService = getIt();

  StreamSubscription<int>? _rssiSub;
  StreamSubscription<bool>? _connectionSub;

  void _doConnected(DoConnectedEvent event, Emitter<ConnectedDeviceState> emit) async {

    emit(LoadingState());

    final device = _nearbyService.connectedDevice;
    
    if (device != null) {
      await _nearbyService.estimateProximity(device);
    }

    try {
      dev.log("pasok dito?");
      await _connectionSub?.cancel();

      await emit.forEach<bool>(
        _nearbyService.isConnectedStream,
        onData: (connected) {
          final device = _nearbyService.connectedDevice;
          if (connected && device != null) {
            _rssiSub?.cancel();
            _rssiSub = _nearbyService.latencyStream(const Duration(seconds: 3)).listen((latency) {
              add(UpdateRssiEvent(rssi: latency));
            });

            return LoadedState(
              distance: -1,
              id: _sharedPreferencesManager.lastConnectedDeviceId,
              deviceName: _sharedPreferencesManager.lastConnectedDeviceName,
            );
          } else {
            return state;
          }
        },
      );
    } catch (e) {
      dev.log("Error connecting: ${e.toString()}");
      add(DoDisconnectEvent());
      emit(ErrorState(message: e.toString()));
    }
  }

  void _isConnected(IsConnectedEvent event, Emitter<ConnectedDeviceState> emit) {
    _connectionSub?.cancel();
    _connectionSub = _nearbyService.isConnectedStream.listen((connected) {
      dev.log("isConnected: $connected");

      if (connected) {
        add(DoConnectedEvent());
      } 
    });
  }

  void _doDisconnect(DoDisconnectEvent event, Emitter<ConnectedDeviceState> emit) async {
    await _rssiSub?.cancel();
    await _sharedPreferencesManager.setLastConnectedDevice(id: "", name: "");
    emit(
      LoadedState(
        distance: 0,
        id: "",
        deviceName: "",
      ),
    );
  }

  void _updateRssi(UpdateRssiEvent event, Emitter<ConnectedDeviceState> emit) {
    final device = _nearbyService.connectedDevice;
    if (device == null) return;

    final latency = event.rssi;

    final distance = _calculateDistanceFromLatency(latency);

    emit(
      LoadedState(
        distance: distance,
        id: device.info.id,
        deviceName: device.info.displayName,
      ),
    );
  }


  double _calculateDistanceFromLatency(int latencyMs) {
    if (latencyMs <= 0) return -1.0;
    return latencyMs / 3.0;
  }


  @override
  Future<void> close() {
    _rssiSub?.cancel();
    _connectionSub?.cancel();
    return super.close();
  }
}
