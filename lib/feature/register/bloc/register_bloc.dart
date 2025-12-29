import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../di/_dependencies.dart';
import '../../../di/shared_preferences_manager.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {

  final SharedPreferencesManager _sharedPreferencesManager = getIt();

  RegisterBloc() : super(InitialState()) {
    on<DoRegisterEvent>(_doRegister);
  }

  void _doRegister(DoRegisterEvent event, Emitter<RegisterState> emit) async {
    await _sharedPreferencesManager.setLoggedIn(true);
    emit(LoadedState());
  }
}