part of 'sending_bloc.dart';

sealed class SendingState {
  String get deviceName => '';
  List<NearbyFileInfo> get filesInfo => [];
}

class SendingInitial extends SendingState {}

class SendingInProgress extends SendingState {
  final int progress;

  @override
  final String deviceName;
  @override
  final List<NearbyFileInfo> filesInfo;

  SendingInProgress({
    required this.progress,
    required this.deviceName,
    required this.filesInfo,
  });
}

class SendingSuccess extends SendingState {}
