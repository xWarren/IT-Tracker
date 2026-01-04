import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';

import 'package:nearby_service/nearby_service.dart' as nearby;
import '../../../core/domain/entity/send_file_history_entity.dart';
import '../../../core/domain/service/nearby_service.dart';
import '../../../di/_dependencies.dart';
import '../../../di/send_file_history_storage.dart';
import '../../../di/shared_preferences_manager.dart';
import '../../receive/bloc/receive_bloc.dart';

part 'send_file_event.dart';
part 'send_file_state.dart';

class SendFileBloc extends Bloc<SendFileEvent, SendFileState> {

  SendFileBloc() : super(SendFileInitial()) {
    on<SendFilesEvent>(_onSendFiles);
  }

  final NearbyService _nearbyService = getIt();
  final ReceiveBloc receiveBloc = getIt();

  final SharedPreferencesManager _sharedPreferencesManager = getIt();
  final SendFileHistoryStorage _historyStorage = getIt();

  Future<void> _onSendFiles(SendFilesEvent event, Emitter<SendFileState> emit) async {
    if (!_nearbyService.isConnected) {
      emit(SendFileError("No device connected"));
      return;
    }

    emit(SendFileSending(deviceName: _sharedPreferencesManager.lastConnectedDeviceName, files: event.files));

    try {
      final nearbyFiles = event.files.map((file) => nearby.NearbyFileInfo(path: file.path)).toList();
      final request = nearby.NearbyMessageFilesRequest.create(files: nearbyFiles);

      await _nearbyService.send(request);

      final histories = event.files.map((file) {
      return SentFileHistoryEntity(
          fileName: "You sent a file ${file.uri.pathSegments.last}",
          path: file.path,
          size: file.lengthSync(),
          sentAt: DateTime.now(),
        );
      }).toList();

      await _historyStorage.saveFiles(histories);
      

      emit(SendFileSent());
    } catch (e) {
      emit(SendFileError("Failed to send files: $e"));
    }
  }

}
