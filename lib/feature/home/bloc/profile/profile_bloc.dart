import 'package:bloc/bloc.dart';

import '../../../../di/_dependencies.dart';
import '../../../../di/shared_preferences_manager.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {

  final SharedPreferencesManager _sharedPreferencesManager = getIt();

  ProfileBloc() : super(InitialState()) {
    on<DoGetProfileEvent>(_doGetProfile);
  }

  void _doGetProfile(DoGetProfileEvent event, Emitter<ProfileState> emit) {
    emit(LoadingState());

    if (_sharedPreferencesManager.hasName.isNotEmpty) {
      emit(LoadedState());
    } else {
      emit(ErrorState(message: ""));
    }
  }
}