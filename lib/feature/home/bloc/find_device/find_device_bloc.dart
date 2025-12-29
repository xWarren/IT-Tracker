import 'package:bloc/bloc.dart';

part 'find_device_event.dart';
part 'find_device_state.dart';

class FindDeviceBloc extends Bloc<FindDeviceEvent, FindDeviceState> {

  FindDeviceBloc() : super(InitialState()) {
    on<DoConnectEvent>(_doConnect);
  }

  void _doConnect(DoConnectEvent event, Emitter<FindDeviceState> emit) {}
}