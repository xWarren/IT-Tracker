part of 'set_profile_2_bloc.dart';

sealed class SetProfile2Event {}

class DoSetProfileEvent extends SetProfile2Event {
  final File? file;
  final String name;
  final String phoneNumber;
  DoSetProfileEvent({
    required this.file,
    required this.name,
    required this.phoneNumber
  });
}