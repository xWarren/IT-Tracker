import 'package:bloc/bloc.dart';
import '../../di/shared_preferences_manager.dart';

class RangeLimitCubit extends Cubit<List<int>> {
  final SharedPreferencesManager _prefs;

  RangeLimitCubit(this._prefs) : super(_prefs.getRangeLimits());

  void addRange(int value) {
    final list = List<int>.from(state)..add(value);
    emit(list);
  }

  void removeRangeAt(int index) {
    final list = List<int>.from(state)..removeAt(index);
    emit(list);
  }

  void updateRange(int index, int value) {
    final list = List<int>.from(state);
    if (index < list.length) {
      list[index] = value;
      emit(list);
    }
  }

  Future<void> save() async {
    await _prefs.setRangeLimits(state);
  }
}
