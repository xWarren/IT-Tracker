import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:splash_master/core/splash_master.dart';

import 'core/cubit/connectivity_cubit.dart';
import 'core/resources/app_router.dart';
import 'core/resources/theme.dart';
import 'di/_dependencies.dart';
import 'feature/home/bloc/find_device/find_device_bloc.dart';
import 'feature/home/bloc/profile/profile_bloc.dart';
import 'feature/login/bloc/login_bloc.dart';
import 'feature/onboarding/bloc/onboarding_bloc.dart';
import 'feature/register/bloc/register_bloc.dart';
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
        BlocProvider(
          create: (_) => FindDeviceBloc()
        ),
        BlocProvider(
          create: (_) => ProfileBloc()
        ),
        BlocProvider(
          create: (_) => ConnectivityCubit()
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'I Tracker',
        theme: AppTheme.lightTheme, 
        routerConfig: AppRouter.router
      ),
    );
  }
}