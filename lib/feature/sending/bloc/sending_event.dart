part of 'sending_bloc.dart';

sealed class SendingEvent {}

class StartSending extends SendingEvent {
  final String deviceName;
  final List<NearbyFileInfo> files;

  StartSending({
    required this.deviceName,
    required this.files,
  });
}

class SendingProgressUpdated extends SendingEvent {
  final int progress;
  SendingProgressUpdated(this.progress);
}

class SendingCompleted extends SendingEvent {}

class StopSending extends SendingEvent {}
