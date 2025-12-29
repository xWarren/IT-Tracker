part of '_dependencies.dart';

Future<void> _initApp() async {

  getIt.registerLazySingletonAsync<SharedPreferences>(() async => await SharedPreferences.getInstance());
  await getIt.isReady<SharedPreferences>();
  getIt.registerSingletonWithLog<SharedPreferencesManager>(SharedPreferencesManager(getIt<SharedPreferences>()));
}
