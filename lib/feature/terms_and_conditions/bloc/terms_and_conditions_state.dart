part of 'terms_and_conditions_bloc.dart';

sealed class TermsAndConditionsState {}

class InitialState extends TermsAndConditionsState {}

class LoadingState extends TermsAndConditionsState {}

class LoadedState extends TermsAndConditionsState {}

class ErrorState extends TermsAndConditionsState {
  final String message;
  ErrorState({required this.message});
}

