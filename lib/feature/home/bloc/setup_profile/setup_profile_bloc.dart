import 'package:bloc/bloc.dart';

import '../../../../di/_dependencies.dart';
import '../../../../di/shared_preferences_manager.dart';

part 'setup_profile_event.dart';
part 'setup_profile_state.dart';

class SetupProfileBloc extends Bloc<SetupProfileEvent, SetupProfileState> {

  final SharedPreferencesManager _sharedPreferencesManager = getIt();

  SetupProfileBloc() : super(InitialState()) {
    on<DoSetupProfileEvent>(_doSetupProfile);
  }

  void _doSetupProfile(DoSetupProfileEvent event, Emitter<SetupProfileState> emit) {
    _sharedPreferencesManager.setProfilePicture(event.profilePicture);
    _sharedPreferencesManager.setName(event.name);
    _sharedPreferencesManager.setPhoneNumebr(event.phoneNumber);
  }
}