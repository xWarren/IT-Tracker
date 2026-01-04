part of '_dependencies.dart';

Future<void> _initApp() async {

  getIt.registerLazySingletonAsync<SharedPreferences>(() async => await SharedPreferences.getInstance());
  await getIt.isReady<SharedPreferences>();
  getIt.registerSingletonWithLog<SharedPreferencesManager>(SharedPreferencesManager(getIt<SharedPreferences>()));
  getIt.registerSingletonWithLog<SendFileHistoryStorage>(SendFileHistoryStorage());
  getIt.registerLazySingleton<ConnectivityCubit>(() => ConnectivityCubit());
  getIt.registerLazySingleton<GoRouterRefresh>(() => GoRouterRefresh(getIt<ConnectivityCubit>()));
  getIt.registerLazySingleton<FlutterBluePlus>(() => FlutterBluePlus());
  getIt.registerSingletonWithLog<NearbyService>(NearbyService());
  getIt.registerSingleton<ReceiveBloc>(ReceiveBloc());
  getIt.registerSingleton<ConversationBloc>(ConversationBloc());
  getIt.registerSingleton<SendingBloc>(SendingBloc());
  getIt.registerSingleton<FindDeviceBloc>(FindDeviceBloc(receiveBloc: getIt(), conversationBloc: getIt(), sendingBloc: getIt()));
}
