part of 'receive_bloc.dart';

sealed class ReceiveState {}

class ReceiveFileInitial extends ReceiveState {}

class ReceiveFileRequesting extends ReceiveState {
  final int requestId;
  final int filesCount;
  List<nearby.NearbyFileInfo> filesInfo;
  final String deviceName;
  ReceiveFileRequesting({
    required this.requestId,
    required this.filesCount,
    required this.filesInfo,
    required this.deviceName
  });
}

class ReceiveFileInProgress extends ReceiveState {
  final int progress;
  final List<nearby.NearbyFileInfo> filesInfo;
  final String deviceName;
  ReceiveFileInProgress(
    this.progress, 
    this.filesInfo,
    this.deviceName
  );
}

class ReceiveFileSuccess extends ReceiveState {
  final String message;
  ReceiveFileSuccess(this.message);
}

class ReceiveFileRejected extends ReceiveState {}

class ReceiveFileError extends ReceiveState {
  final String message;
  ReceiveFileError(this.message);
}
