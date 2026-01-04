import 'package:bloc/bloc.dart';

import '../../../core/domain/entity/send_file_history_entity.dart';
import '../../../di/_dependencies.dart';
import '../../../di/send_file_history_storage.dart';

part 'history_event.dart';
part 'history_state.dart';


class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {

  HistoryBloc() : super(InitialState()) {
    on<DoGetHistoryEvent>(_doGetHistory);
  }

  final SendFileHistoryStorage _historyStorage = getIt();

  void _doGetHistory(DoGetHistoryEvent event, Emitter<HistoryState> emit) async {
    final history = await _historyStorage.getHistory();

    emit(LoadedState(history));
  }
}