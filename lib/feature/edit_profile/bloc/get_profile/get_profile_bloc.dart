import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../di/_dependencies.dart';
import '../../../../di/shared_preferences_manager.dart';

part 'get_profile_event.dart';
part 'get_profile_state.dart';

class GetProfileBloc extends Bloc<GetProfileEvent, GetProfileState> {

  GetProfileBloc() : super(InitialState()) {
    on<DoGetProfileEvent>(_doGetProfile);
  }

  final SharedPreferencesManager _sharedPreferencesManager = getIt();

  void _doGetProfile(DoGetProfileEvent event, Emitter<GetProfileState> emit) {
    emit(
      LoadedState(
        file: _sharedPreferencesManager.getProfilePicture, 
        name: _sharedPreferencesManager.getName, 
        phoneNumber: _sharedPreferencesManager.getPhoneNumber
      )
    );
  }
}