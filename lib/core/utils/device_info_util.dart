import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

class DeviceInfoUtil {
  static final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  static Future<String> getDeviceName() async {
    if (Platform.isAndroid) {
      final androidInfo = await _deviceInfo.androidInfo;
      return "${androidInfo.brand} ${androidInfo.model}";
    }

    if (Platform.isIOS) {
      final iosInfo = await _deviceInfo.iosInfo;
      return iosInfo.name;
    }

    if (Platform.isMacOS) {
      final macInfo = await _deviceInfo.macOsInfo;
      return macInfo.model;
    }

    if (Platform.isWindows) {
      final windowsInfo = await _deviceInfo.windowsInfo;
      return windowsInfo.computerName;
    }

    return "Unknown Device";
  }

  static Future<String> getOSVersion() async {
    if (Platform.isAndroid) {
      final androidInfo = await _deviceInfo.androidInfo;
      return "Android ${androidInfo.version.release}";
    }

    if (Platform.isIOS) {
      final iosInfo = await _deviceInfo.iosInfo;
      return "iOS ${iosInfo.systemVersion}";
    }

    return "Unknown OS";
  }

  static String getPlatform() {
    if (Platform.isAndroid) return "Android";
    if (Platform.isIOS) return "iOS";
    if (Platform.isMacOS) return "macOS";
    if (Platform.isWindows) return "Windows";
    return "Unknown";
  }
}
