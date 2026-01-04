import 'dart:async';
import 'dart:developer' as dev;

import 'package:bloc/bloc.dart';
import 'package:just_audio/just_audio.dart';

import '../../../../core/domain/service/nearby_service.dart';
import '../../../../core/domain/service/notification_service.dart';
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
  final NotificationService _notificationService = getIt();

  final AudioPlayer _audioPlayer = AudioPlayer();

  bool _hasNotified = false;

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

            _notificationService.showNotification(
              id: 1,
              title: "Device Connected",
              body: "${device.info.displayName} is now connected",
              ongoing: true
            );

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
    
    if (_nearbyService.connectedDevice?.info.displayName.isNotEmpty == true) {
      _notificationService.showNotification(
        id: 2,
        title: "Device Disconnected",
        body: "${_nearbyService.connectedDevice?.info.displayName} disconnected",
        ongoing: false
      );
    }

  }

  void _updateRssi(UpdateRssiEvent event, Emitter<ConnectedDeviceState> emit) async {
    final device = _nearbyService.connectedDevice;

    if (device == null) return;

    final latency = event.rssi;

    final distance = latencyToMeters(latency);

    final savedLimits = _sharedPreferencesManager.getRangeLimits();

    final exceeded = savedLimits.any((limit) => distance > limit);

    if (exceeded && !_hasNotified) {
      _hasNotified = true;
      _notificationService.showNotification(
        id: 3,
        title: "Device Out of Range",
        body: "${device.info.displayName} is beyond the set range (${distance.toStringAsFixed(1)} m)",
        ongoing: false,
      );
      await _audioPlayer.addAudioSource(AudioSource.asset('assets/sounds/alarm.WAV'));
      await _audioPlayer.play();

    }

    if (!exceeded) {
      _hasNotified = false;
    }

    emit(
      LoadedState(
        distance: distance,
        id: device.info.id,
        deviceName: device.info.displayName,
      ),
    );
  }


  double latencyToMeters(int latencyMs) {
    if (latencyMs <= 0) return -1;

    // Empirical approximation
    return (latencyMs / 10).clamp(0.5, 30);
  }


  @override
  Future<void> close() {
    _rssiSub?.cancel();
    _connectionSub?.cancel();
    return super.close();
  }
}
