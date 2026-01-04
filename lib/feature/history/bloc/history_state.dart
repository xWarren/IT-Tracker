part of 'history_bloc.dart';

sealed class HistoryState {}

class InitialState extends HistoryState {}

class LoadingState extends HistoryState {}

class LoadedState extends HistoryState {
  final List<SentFileHistoryEntity> histories;
  LoadedState(this.histories);
}

class ErrorState extends HistoryState {
  final String message;
  ErrorState(this.message);
}