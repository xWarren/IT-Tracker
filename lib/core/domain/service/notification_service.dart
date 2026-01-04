import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart' as permission;
import 'package:rxdart/subjects.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() => _instance;

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  final BehaviorSubject<String?> onNotificationClick = BehaviorSubject();

  Future<void> init() async {

    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings();
    final InitializationSettings settings = const InitializationSettings(android: androidSettings, iOS: iosSettings);

    await _flutterLocalNotificationsPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse: onSelectNotification
    );
  }

  void onSelectNotification(NotificationResponse? details) {

    final payload = details?.payload;
    if (payload != null && payload.isNotEmpty) {
      onNotificationClick.add(payload);
    }
  }

  Future<bool?> requestPermissions() async {
    if (Platform.isAndroid) {
      final deviceInfo = await DeviceInfoPlugin().androidInfo;
      if (deviceInfo.version.sdkInt>32) {
        return _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();
      } else {
        return permission.Permission.notification.request().isGranted;
      }
    } else {
      return _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
        alert: true,
        badge: true,
        sound: true
      );
    }
  }

  Future<bool?> isGrantedPermission() async {
    if (Platform.isAndroid) {
      final deviceInfo = await DeviceInfoPlugin().androidInfo;
      if (deviceInfo.version.sdkInt>32) {
        return _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.areNotificationsEnabled();
      } else {
        return permission.Permission.notification.isGranted;
      }
    } else {
      final checkPermission = await _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.checkPermissions();
      return ((checkPermission?.isEnabled ?? false) && 
      (checkPermission?.isAlertEnabled ?? false) && 
      (checkPermission?.isBadgeEnabled ?? false) && 
      (checkPermission?.isSoundEnabled ?? false)) || (checkPermission?.isEnabled ?? true);
    }
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    required bool ongoing
  }) async {
    final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'nearby_channel',
      'Nearby Notifications',
      channelDescription: 'Notifications from Nearby Service',
      importance: Importance.max,
      priority: Priority.high,
      ongoing: ongoing,
      icon: '@mipmap/ic_launcher',
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();

    final NotificationDetails details = NotificationDetails(android: androidDetails, iOS: iosDetails);

    await _flutterLocalNotificationsPlugin.show(id, title, body, details);
  }
}
