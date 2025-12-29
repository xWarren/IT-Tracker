import 'package:bloc/bloc.dart';

import '../../../di/_dependencies.dart';
import '../../../di/shared_preferences_manager.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {

  final SharedPreferencesManager _sharedPreferencesManager = getIt();

  OnboardingBloc() : super(InitialState()) {
    on<DoneOnboardingEvent>(_doneOnboarding);
  }

  void _doneOnboarding(DoneOnboardingEvent event, Emitter<OnboardingState> emit) async {
    await _sharedPreferencesManager.setSeenOnboarding(true);
    emit(LoadedState());
  }
}