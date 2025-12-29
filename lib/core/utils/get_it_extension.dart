import 'dart:developer';

import 'package:get_it/get_it.dart';

extension GetItExt on GetIt {

  T? tryGet<T extends Object>() {
    return isRegistered<T>() ? get<T>() : null;
  }

  void registerSingletonWithLog<T extends Object>(T instance) {
    registerSingleton<T>(instance);
    log('Registered Singleton: ${T.toString()}');
  }
}