import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/file_saver.dart';
import '../../../../di/_dependencies.dart';
import '../../../../di/shared_preferences_manager.dart';

part 'set_profile_event.dart';
part 'set_profile_state.dart';

class SetProfileBloc extends Bloc<SetProfileEvent, SetProfileState> {

  SetProfileBloc() : super(InitialState()) {
    on<DoSetProfileEvent>(_doSetProfile);
  }

  final SharedPreferencesManager _sharedPreferencesManager = getIt();

  Future<void> _doSetProfile(DoSetProfileEvent event, Emitter<SetProfileState> emit) async {
    emit(LoadingState());

    String? profileImagePath;

    if (event.file != null) {
      profileImagePath = await FilesSaver.saveProfileImage(event.file ?? File(""));
    }
    

    await Future.delayed(const Duration(seconds: 3));

    await _sharedPreferencesManager.setName(event.name);
    await _sharedPreferencesManager.setPhoneNumber(event.phoneNumber);

    if (profileImagePath != null) {
      await _sharedPreferencesManager.setProfilePicture(profileImagePath);
    }
    emit(LoadedState());
  }
}