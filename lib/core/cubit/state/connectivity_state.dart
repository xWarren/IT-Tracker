part of '../connectivity_cubit.dart';

abstract class ConnectivityState {}

class ConnectivityLoading extends ConnectivityState {}

class ConnectivityLoaded extends ConnectivityState {
  final ConnectivityStatusEnum status;

  ConnectivityLoaded({required this.status});

  bool get isConnected => status == ConnectivityStatusEnum.connected;
}

class ConnectivityError extends ConnectivityState {
  final String message;

  ConnectivityError(this.message);
}
