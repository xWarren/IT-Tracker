part of 'register_bloc.dart';

sealed class RegisterEvent {}

class DoRegisterEvent extends RegisterEvent {
  final String email;
  final String password;
  DoRegisterEvent({
    required this.email,
    required this.password
  });
}