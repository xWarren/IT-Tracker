import 'package:bloc/bloc.dart';
import '../domain/service/notification_service.dart';
import 'state/notification_permission_state.dart';

class NotificationPermissionCubit extends Cubit<NotificationPermissionState> {
  NotificationPermissionCubit() : super(NotificationPermissionInitial());

  final NotificationService _notificationService = NotificationService();

  Future<void> checkPermission() async {
    emit(NotificationPermissionChecking());
    try {
      final granted = await _notificationService.isGrantedPermission();
      if (granted == true) {
        emit(NotificationPermissionGranted());
      } else {
        emit(NotificationPermissionDenied());
      }
    } catch (e) {
      emit(NotificationPermissionDenied());
    }
  }

  Future<void> requestPermission() async {
    try {
      final granted = await _notificationService.requestPermissions();
      if (granted == true) {
        emit(NotificationPermissionGranted());
      } else {
        emit(NotificationPermissionDenied());
      }
    } catch (e) {
      emit(NotificationPermissionDenied());
    }
  }
}
