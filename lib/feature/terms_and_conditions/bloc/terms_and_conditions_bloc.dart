import 'package:bloc/bloc.dart';

import '../../../di/_dependencies.dart';
import '../../../di/shared_preferences_manager.dart';

part 'terms_and_conditions_event.dart';
part 'terms_and_conditions_state.dart';

class TermsAndConditionsBloc extends Bloc<TermsAndConditionsEvent, TermsAndConditionsState> {

  final SharedPreferencesManager _sharedPreferencesManager = getIt();

  TermsAndConditionsBloc() : super(InitialState()) {
    on<DoContinueEvent>(_doContinue);
  }

  void _doContinue(DoContinueEvent event, Emitter<TermsAndConditionsState> emit) async {
    await _sharedPreferencesManager.setSeenTermsAndCondition(true);
    emit(LoadedState());
  }
}