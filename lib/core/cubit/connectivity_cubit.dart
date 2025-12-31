import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../utils/connectivity_util.dart';
import '../utils/enum/connectivity_status_enum.dart';

part 'state/connectivity_state.dart';

class ConnectivityCubit extends Cubit<ConnectivityState> {
  StreamSubscription<bool>? _subscription;

  ConnectivityCubit() : super(ConnectivityLoading()) {
    _init();
  }

  Future<void> _init() async {
    try {
      final hasInternet = await ConnectivityUtil.hasInternet();

      emit(
        ConnectivityLoaded(
          status: hasInternet
              ? ConnectivityStatusEnum.connected
              : ConnectivityStatusEnum.disconnected,
        ),
      );

      _subscription =
          ConnectivityUtil.connectivityStream().listen((isConnected) {
        emit(
          ConnectivityLoaded(
            status: isConnected
                ? ConnectivityStatusEnum.connected
                : ConnectivityStatusEnum.disconnected,
          ),
        );
      });
    } catch (e) {
      emit(ConnectivityError(e.toString()));
    }
  }

  bool get hasInternet => state is ConnectivityLoaded &&(state as ConnectivityLoaded).isConnected;

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
