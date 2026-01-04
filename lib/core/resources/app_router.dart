import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../di/_dependencies.dart';
import '../../di/shared_preferences_manager.dart';
import '../../feature/add_user/add_user_page.dart';
import '../../feature/chat/chat_page.dart';
import '../../feature/conversation/conversation_page.dart';
import '../../feature/edit_profile/edit_profile_page.dart';
import '../../feature/find_device/find_device_page.dart';
import '../../feature/history/history_page.dart';
import '../../feature/home/home_page.dart';
import '../../feature/onboarding/onboarding_page.dart';
import '../../feature/receive/receive_page.dart';
import '../../feature/register/register_page.dart';
import '../../feature/send_file/send_file_page.dart';
import '../../feature/sending/sending_page.dart';
import '../../feature/settings/settings_page.dart';
import '../../feature/terms_and_conditions/terms_and_conditions_page.dart';
import '../../feature/login/login_page.dart';
import '../cubit/connectivity_cubit.dart';
import '../utils/enum/slide_direction_enum.dart';
import '../utils/go_router_extension.dart';
import 'app_routes.dart';
import 'go_router_refresh.dart';
import 'keys.dart';

class AppRouter {

  static final connectivityCubit = getIt<ConnectivityCubit>();
  static final refresh = getIt<GoRouterRefresh>();

  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.home,
    refreshListenable: refresh,

    redirect: (context, state) {
      final prefs = getIt<SharedPreferencesManager>();
      final location = state.matchedLocation;

      if (!prefs.hasSeenOnboarding && location != AppRoutes.onboarding) {
        return AppRoutes.onboarding;
      }

      if (prefs.hasSeenOnboarding &&!prefs.hasSeenTermsAndConditions && location != AppRoutes.termsandconditions) {
        return AppRoutes.termsandconditions;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.onboarding, 
        builder: (context, state) {
          return const OnboardingPage();
        },
      ),
      GoRoute(
        path: AppRoutes.termsandconditions, 
        builder: (context, state) {
          return const TermsAndConditionsPage();
        },
      ),
      GoRoute(
        path: AppRoutes.login, 
        builder: (context, state) {
          return const LoginPage();
        },
      ),
      GoRoute(
        path: AppRoutes.register, 
        builder: (context, state) {
          return const RegisterPage();
        },
      ),
      GoRoute(
        path: AppRoutes.home, 
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: const HomePage(),
            transitionsBuilder: (context, animation, _, child) {
              return FadeTransition(
                opacity: animation,
                child: ScaleTransition(
                  scale: Tween(begin: 0.95, end: 1.0).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOut,
                    ),
                  ),
                  child: child,
                ),
              );
            },
          );
        },
      ),
      GoRoute(
        path: AppRoutes.chat, 
        pageBuilder: (context, state) {
          return state.slide(
            child: const ChatPage(),
            direction: SlideDirectionEnum.up
          );
        },
      ),
      GoRoute(
        path: AppRoutes.findDevice, 
        pageBuilder: (context, state) {
          return state.slide(child: const FindDevicePage());
        },
      ),
      GoRoute(
        path: AppRoutes.sendFile, 
        pageBuilder: (context, state) {
          return state.slide(child: const SendFilePage());
        },
      ),
      GoRoute(
        path: AppRoutes.sending, 
        pageBuilder: (context, state) {
          final args = state.extra as Map<String, dynamic>;
          return state.slide(
            child: SendingPage(
              deviceName: args[Keys.deviceNameKey],
            )
          );
        },
      ),
      GoRoute(
        path: AppRoutes.receive, 
        pageBuilder: (context, state) {
          return state.slide(child: const ReceivePage());
        },
      ),
      GoRoute(
        path: AppRoutes.settings, 
        pageBuilder: (context, state) {
          return state.slide(
            child: const SettingsPage(),
            direction: SlideDirectionEnum.up
          );
        },
      ),
      GoRoute(
        path: AppRoutes.editProfile,
        pageBuilder: (context, state) {
          return state.slide(
            child: const EditProfilePage(),
            direction: SlideDirectionEnum.up
          );
        },
      ),
      GoRoute(
        path: AppRoutes.addUser, 
        pageBuilder: (context, state) {
          return state.slide(
            child: const AddUserPage(),
            direction: SlideDirectionEnum.up
          );
        },
      ),
      GoRoute(
        path: AppRoutes.conversation, 
        pageBuilder: (context, state) {
          final args = state.extra as Map<String, dynamic>;
          return state.slide(
            child: ConversationPage(
              deviceId: args[Keys.deviceIdKey],
              deviceName: args[Keys.deviceNameKey],
            )
          );
        },
      ),
      GoRoute(
        path: AppRoutes.history, 
        pageBuilder: (context, state) {
          return state.slide(child: const HistoryPage());
        },
      ),
    ]
  );
}