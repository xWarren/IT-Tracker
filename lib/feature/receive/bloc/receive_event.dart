part of 'receive_bloc.dart';

sealed class ReceiveEvent {}

class FilesRequestReceived extends ReceiveEvent {
  final int requestId;
  final int filesCount;
  List<nearby.NearbyFileInfo> filesInfo;
  final String deviceName;
  FilesRequestReceived({
    required this.requestId,
    required this.filesCount,
    required this.filesInfo,
    required this.deviceName
  });
}

class FilesAccepted extends ReceiveEvent {
  final int requestId;
  final List<nearby.NearbyFileInfo> filesInfo;
  final String deviceName;
  FilesAccepted(
    this.requestId, 
    this.filesInfo,
    this.deviceName
  );
}

class FilesRejected extends ReceiveEvent {
  final int requestId;
  FilesRejected(this.requestId);
}

class FilesProgressUpdated extends ReceiveEvent {
  final int progress;
  List<nearby.NearbyFileInfo> filesInfo;
  final String deviceName;
  FilesProgressUpdated(
    this.progress, 
    this.filesInfo,
    this.deviceName
  );
}

class FilesSaved extends ReceiveEvent {
  final List<nearby.NearbyFileInfo> filesInfo;
  final String message;
  FilesSaved(this.filesInfo, this.message);
}
