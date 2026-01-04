part of 'set_profile_bloc.dart';

sealed class SetProfileEvent {}

class DoSetProfileEvent extends SetProfileEvent {
  final File? file;
  final String name;
  final String phoneNumber;
  DoSetProfileEvent({
    required this.file,
    required this.name,
    required this.phoneNumber
  });
}