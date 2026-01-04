part of 'send_file_bloc.dart';

sealed class SendFileEvent {}

class SendFilesEvent extends SendFileEvent {
  final List<File> files;
  SendFilesEvent(this.files);
}
