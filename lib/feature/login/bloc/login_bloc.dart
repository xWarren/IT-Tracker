import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../di/_dependencies.dart';
import '../../../di/shared_preferences_manager.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {

  final SharedPreferencesManager _sharedPreferencesManager = getIt();

  LoginBloc() : super(InitialState()) {
    on<DoLoginEvent>(_doLogin);
  }

  void _doLogin(DoLoginEvent event, Emitter<LoginState> emit) async {
    await _sharedPreferencesManager.setLoggedIn(true);
    emit(LoadedState());
  }
}