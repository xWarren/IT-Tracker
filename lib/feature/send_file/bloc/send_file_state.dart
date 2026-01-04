part of 'send_file_bloc.dart';

sealed class SendFileState {}

class SendFileInitial extends SendFileState {}

class SendFileSending extends SendFileState {
  final String deviceName;
  final List<File> files;
  SendFileSending({
    required this.deviceName,
    required this.files
  });
}

class SendFileSent extends SendFileState {}

class SendFileError extends SendFileState {
  final String message;
  SendFileError(this.message);
}
