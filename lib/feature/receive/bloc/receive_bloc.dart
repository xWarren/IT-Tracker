import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nearby_service/nearby_service.dart' as nearby;

import '../../../core/domain/entity/send_file_history_entity.dart';
import '../../../core/domain/service/nearby_service.dart';
import '../../../di/_dependencies.dart';
import '../../../di/send_file_history_storage.dart';

part 'receive_event.dart';
part 'receive_state.dart';

class ReceiveBloc extends Bloc<ReceiveEvent, ReceiveState> {

  ReceiveBloc() : super(ReceiveFileInitial()) {
    on<FilesRequestReceived>(_onFilesRequestReceived);
    on<FilesAccepted>(_onFilesAccepted);
    on<FilesRejected>(_onFilesRejected);
    on<FilesSaved>(_onFilesSaved);
    on<FilesProgressUpdated>((event, emit) {
      log("event.progress ${event.progress}");
      emit(ReceiveFileInProgress(event.progress, event.filesInfo, event.deviceName));
    });
  }

  final NearbyService _nearbyService = getIt();
  final SendFileHistoryStorage _historyStorage = getIt();

  void _onFilesRequestReceived(FilesRequestReceived event,Emitter<ReceiveState> emit) {
    emit(ReceiveFileRequesting(requestId: event.requestId, filesCount: event.filesCount, filesInfo: event.filesInfo, deviceName: event.deviceName));
  }

  Future<void> _onFilesAccepted(FilesAccepted event,Emitter<ReceiveState> emit) async {
    try {
      emit(ReceiveFileInProgress(event.requestId, event.filesInfo, event.deviceName));

      await _nearbyService.send(
        nearby.NearbyMessageFilesResponse(
          id: event.requestId.toString(),
          isAccepted: true,
        ),
      );
    } catch (e) {
      emit(ReceiveFileError("Failed to accept files"));
    }
  }

  Future<void> _onFilesRejected(FilesRejected event,Emitter<ReceiveState> emit) async {
    try {
      await _nearbyService.send(
        nearby.NearbyMessageFilesResponse(
          id: event.requestId.toString(),
          isAccepted: false,
        ),
      );

      emit(ReceiveFileRejected());
    } catch (e) {
      emit(ReceiveFileError("Failed to reject files"));
    }
  }

  void _onFilesSaved(FilesSaved event,Emitter<ReceiveState> emit) async {
    final histories = event.filesInfo.map((info) {
      return SentFileHistoryEntity(
        fileName: "You received a file ${info.name}",
        path: "",
        size: 0,
        sentAt: DateTime.now(),
      );
    }).toList();

    await _historyStorage.saveFiles(histories);

    emit(ReceiveFileSuccess(event.message));
  }
}
