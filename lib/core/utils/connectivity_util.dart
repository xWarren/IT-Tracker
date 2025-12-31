import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityUtil {

  static final Connectivity _connectivity = Connectivity();

  static Future<bool> hasInternet() async {
    final results = await _connectivity.checkConnectivity();
    return _isConnected(results);
  }

  static Stream<bool> connectivityStream() {
    return _connectivity.onConnectivityChanged
        .map((results) => _isConnected(results));
  }

  static bool _isConnected(List<ConnectivityResult> results) {
    return results.contains(ConnectivityResult.mobile) || results.contains(ConnectivityResult.wifi) || results.contains(ConnectivityResult.ethernet);
  }
}
