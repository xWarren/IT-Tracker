part of 'onboarding_bloc.dart';

sealed class OnboardingState {}

class InitialState extends OnboardingState {}

class LoadingState extends OnboardingState {}

class LoadedState extends OnboardingState {}

class ErrorState extends OnboardingState {
  final String message;
  ErrorState({required this.message});
}