part of 'setup_profile_bloc.dart';

sealed class SetupProfileEvent {}

class DoSetupProfileEvent extends SetupProfileEvent {
  final String profilePicture;
  final String name;
  final String phoneNumber;
  DoSetupProfileEvent({
    required this.profilePicture,
    required this.name,
    required this.phoneNumber
  });
}