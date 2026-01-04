import 'package:bloc/bloc.dart';
import 'package:nearby_service/nearby_service.dart';

part 'sending_event.dart';
part 'sending_state.dart';

class SendingBloc extends Bloc<SendingEvent, SendingState> {

  SendingBloc() : super(SendingInitial()) {
    on<StartSending>(_onStartSending);
    on<SendingProgressUpdated>(_onProgressUpdated);
    on<SendingCompleted>(_onCompleted);
    on<StopSending>(_onStopSending);
  }

  void _onStartSending(StartSending event,Emitter<SendingState> emit,) {
    emit(SendingInProgress(
      deviceName: event.deviceName,
      filesInfo: event.files,
      progress: 0,
    ));
  }

  void _onProgressUpdated(SendingProgressUpdated event,Emitter<SendingState> emit) {
    emit(SendingInProgress(
      deviceName: state.deviceName,
      filesInfo: state.filesInfo,
      progress: event.progress,
    ));
  }

  void _onCompleted(SendingCompleted event,Emitter<SendingState> emit) {
    emit(SendingSuccess());
  }

  void _onStopSending(StopSending event,Emitter<SendingState> emit) {
    emit(SendingInitial());
  }
}
