import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:splash_master/core/splash_master.dart';

import 'core/cubit/connectivity_cubit.dart';
import 'core/resources/app_router.dart';
import 'core/resources/theme.dart';
import 'di/_dependencies.dart';
import 'feature/conversation/bloc/conversation_bloc.dart';
import 'feature/edit_profile/bloc/set_profile_2/set_profile_2_bloc.dart';
import 'feature/history/bloc/history_bloc.dart';
import 'feature/home/bloc/conneceted_device/connected_device_bloc.dart';
import 'feature/find_device/bloc/find_device/find_device_bloc.dart';
import 'feature/home/bloc/profile/profile_bloc.dart';
import 'feature/home/bloc/set_profile/set_profile_bloc.dart';
import 'feature/login/bloc/login_bloc.dart';
import 'feature/onboarding/bloc/onboarding_bloc.dart';
import 'feature/receive/bloc/receive_bloc.dart';
import 'feature/register/bloc/register_bloc.dart';
import 'feature/send_file/bloc/send_file_bloc.dart';
import 'feature/edit_profile/bloc/get_profile/get_profile_bloc.dart';
import 'feature/sending/bloc/sending_bloc.dart';
import 'feature/terms_and_conditions/bloc/terms_and_conditions_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SplashMaster.initialize();
  await initDependencies();
  SplashMaster.resume();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final receiveBloc = ReceiveBloc();
    final conversationBloc = ConversationBloc();
    final sendingBloc = SendingBloc();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => OnboardingBloc()
        ),
        BlocProvider(
          create: (_) => TermsAndConditionsBloc()
        ),
        BlocProvider(
          create: (_) => LoginBloc()
        ),
        BlocProvider(
          create: (_) => RegisterBloc()
        ),
        BlocProvider.value(value: receiveBloc),
        BlocProvider.value(value: conversationBloc),
        BlocProvider.value(value: sendingBloc),
        BlocProvider(
          create: (_) { 
            return FindDeviceBloc(
              receiveBloc: receiveBloc,
              conversationBloc: conversationBloc,
              sendingBloc: sendingBloc
            );
          }
        ),
        BlocProvider(
          create: (_) => ProfileBloc()
        ),
        BlocProvider(
          create: (_) => ConnectivityCubit()
        ),
        BlocProvider(
          create: (_) => ConnectedDeviceBloc()
        ),
        BlocProvider(
          create: (_) => SendFileBloc(),
        ),
        BlocProvider(
          create: (_) => HistoryBloc(),
        ),
        BlocProvider(
          create: (_) => SetProfileBloc(),
        ),
        BlocProvider(
          create: (_) => GetProfileBloc(),
        ),
        BlocProvider(
          create: (_) => SetProfile2Bloc(),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'iTracker',
        theme: AppTheme.lightTheme, 
        routerConfig: AppRouter.router
      ),
    );
  }
}