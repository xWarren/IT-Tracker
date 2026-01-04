import 'dart:developer';

import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/cubit/connectivity_cubit.dart';
import '../../core/cubit/notification_permission_cubit.dart';
import '../../core/cubit/state/notification_permission_state.dart';
import '../../core/resources/colors.dart';
import '../../core/resources/dimensions.dart';
import '../../core/utils/context_extension.dart';
import '../find_device/bloc/find_device/find_device_bloc.dart' hide ErrorState;
import '_components/connected_device.dart';
import '_components/file_transfer.dart';
import '_components/find_device.dart';
import '_components/online_menu.dart';
import 'bloc/conneceted_device/connected_device_bloc.dart' hide LoadedState, ErrorState;
import 'bloc/profile/profile_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String _profilePicture = "";

  @override
  void initState() {
    super.initState();
    _getProfile();
    _stopDiscover();
    _checkPermission();
  }

  void _getProfile() => context.read<ProfileBloc>().add(DoGetProfileEvent());

  void _stopDiscover() {
    context.read<FindDeviceBloc>().add(StopDiscoverEvent());
    _disconnect();
  }
  

  void _disconnect() {
    context.read<ConnectedDeviceBloc>().add(DoDisconnectEvent());
  }

  void _showStatus() {
    context.showStatus(
      title: "Are you sure you want to disconnect?", 
      description: "", 
      buttonTitle: "Disconnect", 
      onButtonPressed: () {
        _stopDiscover();
        context.dismissDialog();
      },
      buttonTitle2: "Cancel",
      onButtonPressed2: context.pop
    );
  }

  void _openBluetoothSettings() async {
    final intent = const AndroidIntent(
      action: 'android.settings.BLUETOOTH_SETTINGS',
    );
    intent.launch();
  }

  void _notificationPermission() {
    context.read<NotificationPermissionCubit>().requestPermission();
  }

  void _checkPermission() {
    context.read<NotificationPermissionCubit>().checkPermission();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotificationPermissionCubit, NotificationPermissionState>(
      listener: (context, state) {
        if (state is NotificationPermissionChecking) {

        } else if (state is NotificationPermissionGranted) {
        } else if (state is NotificationPermissionDenied) {
          _notificationPermission();
        }
      },
      builder: (context, state) {        
        return Material(
          color: CustomColors.white.withValues(alpha: 0.9),
          child: AnnotatedRegion<SystemUiOverlayStyle>(
            value: const SystemUiOverlayStyle(
              statusBarIconBrightness: Brightness.light,
              statusBarBrightness: Brightness.light,
              statusBarColor: CustomColors.white,
            ),
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 200 + 100 + (4 * 216),
                    child: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.topCenter,
                      children: [
                        BlocConsumer<ProfileBloc, ProfileState>(
                          listener: (context, state) {
                            if (state is LoadedState) {
                              log("state.profilePicture ${state.profilePicture}");
                              if (state.profilePicture.isEmpty) {
                                context.showSetUpYourProfile();
                              }
                              
                              _profilePicture = state.profilePicture;
                            }
                          },
                          builder: (context, state) {
                            return Container(
                              height: 200,
                              padding: const EdgeInsets.symmetric(
                                horizontal: Dimensions.paddingMedium,
                                vertical: Dimensions.paddingLarge
                              ),
                              width: context.screenWidth,
                              color: CustomColors.primary,
                              child: BlocBuilder<ConnectivityCubit, ConnectivityState>(
                                builder: (context, state) {
                                  // final hasInternet = state is ConnectivityLoaded && state.isConnected;
        
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            "Welcome to",
                                            style: TextStyle(
                                              color: CustomColors.white,
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w400
                                            ),
                                          ),
                                          Text(
                                            "iTracker",
                                            style: TextStyle(
                                              color: CustomColors.white,
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.w600
                                            ),
                                          )
                                        ],
                                      ),
                                      OnlineMenu(profilePicture: _profilePicture)
                                    ],
                                  );
                                }
                              ),
                            );
                          }
                        ),
                        Positioned(
                          top: 150,
                          left: 0,
                          right: 0,
                          child: Column(
                            spacing: Dimensions.spacingMedium,
                            children: [
                              FindDevice(openBluetoothSettings: _openBluetoothSettings),
                              ConnectedDevice(disconnect: _showStatus),
                              const FileTransfer()
                            ]
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}
