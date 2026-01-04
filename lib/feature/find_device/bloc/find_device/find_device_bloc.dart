import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:nearby_service/nearby_service.dart' as nearby;

import '../../../../core/domain/entity/conversation_mesage_entity.dart';
import '../../../../core/domain/service/nearby_service.dart';
import '../../../../core/utils/enum/message_type_enum.dart';
import '../../../../di/_dependencies.dart';
import '../../../../di/shared_preferences_manager.dart';
import '../../../conversation/bloc/conversation_bloc.dart';
import '../../../receive/bloc/receive_bloc.dart';
import '../../../sending/bloc/sending_bloc.dart';


part 'find_device_event.dart';
part 'find_device_state.dart';

class FindDeviceBloc extends Bloc<FindDeviceEvent, FindDeviceState> {

  final ReceiveBloc receiveBloc;
  final ConversationBloc conversationBloc;
  final SendingBloc sendingBloc;

  FindDeviceBloc({required this.receiveBloc, required this.conversationBloc, required this.sendingBloc}) : super(InitialState()) {
    on<InitializeNearbyEvent>(_init);
    on<StartDiscoverEvent>(_startDiscover);
    on<StopDiscoverEvent>(_stopDiscover);
    on<DoConnectEvent>(_connect);
    on<_PeersUpdatedEvent>(_onPeersUpdated);
  }

  final NearbyService nearbyService = getIt();
  final SharedPreferencesManager _sharedPreferencesManager = getIt();

  final List<nearby.NearbyFileInfo> _filesInfo = [];

  int _totalFiles = 0;
  int _completedFiles = 0;
  final List<nearby.NearbyFileInfo> _receivedFiles = [];

  Future<void> _init(InitializeNearbyEvent event, Emitter<FindDeviceState> emit) async {
    emit(InitializingState());

    await nearbyService.init();
    final granted = await nearbyService.isGrantPermission();

    final localDeviceInfo = await nearbyService.localDevice;

    if (!granted) {
      emit(ErrorState("Permission or Wi-Fi not enabled"));
      return;
    }
    if (localDeviceInfo != null) {
      await _sharedPreferencesManager.setLocalDeviceId(localDeviceInfo.id);
      log("Local device ID saved: ${localDeviceInfo.id}");
    } else {
      log("Failed to get local device info");
    }


    emit(InitializedState());
  }

  Future<void> _startDiscover(StartDiscoverEvent event, Emitter<FindDeviceState> emit) async {
    emit(ScanningState());

    await nearbyService.startDiscover((peers) {
      add(_PeersUpdatedEvent(peers));
    });
  }

  void _onPeersUpdated(_PeersUpdatedEvent event, Emitter<FindDeviceState> emit,) {
    emit(ScanResultState(event.peers));
  }

  void _stopDiscover(StopDiscoverEvent event, Emitter<FindDeviceState> emit) async {
    nearbyService.disconnect((_) {});
  }

  Future<void> _connect(DoConnectEvent event, Emitter<FindDeviceState> emit) async {
    emit(ConnectingState(event.device));

    try {
      await nearbyService.connect(
        device: event.device,
        onTextRequestCallBack: (response) {
          log("Text request received: ${response.value}");
          final textValue = response.value;

          if (textValue != 'ping') {
            final msg = ConversationMessageEntity(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              senderId: event.device.info.id,
              receiverId: _sharedPreferencesManager.localDeviceId,
              isMe: false,
              type: MessageTypeEnum.text,
              text: textValue,
              createdAt: DateTime.now(),
            );
            conversationBloc.add(IncomingMessageEvent(msg));
          } else {
            log("Received ping, ignoring.");
          }
        },
        onTextResponseCallBack: (response) {
          log("onTextResponseCallBack: $response");
        },
        onFilesRequestCallBack: (request) async {
          log("Files request received: ${request.files.map((f) => f.name)}");
          for (var file in request.files) {
            final msg = ConversationMessageEntity(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              senderId: event.device.info.id,
              receiverId: _sharedPreferencesManager.localDeviceId,
              isMe: false,
              type: MessageTypeEnum.audio,
              filePath: file.path,
              createdAt: DateTime.now(),
            );

            conversationBloc.add(IncomingMessageEvent(msg));
          }

          _totalFiles = request.files.length;
          _completedFiles = 0;
          _receivedFiles
          ..clear()
          ..addAll(request.files);

          receiveBloc.add(FilesRequestReceived(
            requestId: int.parse(request.id),
            filesCount: request.files.length,
            filesInfo: request.files,
            deviceName: event.device.info.displayName,
          ));
        },
        onFilesResponseCallBack: (response) {
          _completedFiles++;

          final progress =
              ((_completedFiles / _totalFiles) * 100).round();

          receiveBloc.add(
            FilesProgressUpdated(
              progress,
              _receivedFiles,
              event.device.info.displayName,
            ),
          );
        },
        savePackCallBack: (packId) {
          receiveBloc.add(FilesSaved(_filesInfo, "Files pack saved successfully"));
          receiveBloc.add(FilesProgressUpdated(100, _filesInfo, event.device.info.displayName));
        },
      );
      
      await Future.delayed(const Duration(milliseconds: 500));

      await _sharedPreferencesManager.setLastConnectedDevice(
        id: event.device.info.id,
        name: event.device.info.displayName,
      );

      emit(ConnectedState(event.device));
    } catch (e) {
      emit(ErrorState("Failed to connect to device: $e"));
    }
  }

}
