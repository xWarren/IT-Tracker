import 'dart:developer';

import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:nearby_service/nearby_service.dart';

import '../../core/common/common_appbar.dart';
import '../../core/resources/colors.dart';
import '../../core/utils/connectivity_util.dart';
import '../../core/utils/context_extension.dart';
import '../home/bloc/conneceted_device/connected_device_bloc.dart' hide ErrorState;
import '_components/bluetooth_radar.dart';
import '_components/device_list.dart';
import 'bloc/find_device/find_device_bloc.dart';

class FindDevicePage extends StatefulWidget {
  const FindDevicePage({super.key});

  @override
  State<FindDevicePage> createState() => _FindDevicePageState();
}

class _FindDevicePageState extends State<FindDevicePage> {

  List<ScanResult> results = [];

  List<NearbyDevice> _peers = [];

  @override
  void initState() {
    super.initState();
    _initialize();
  }
  

  @override
  void dispose() {
    super.dispose();
  }

  void _initialize() {
    context.read<FindDeviceBloc>().add(InitializeNearbyEvent());
  }

  void _startDiscover() {
    context.read<FindDeviceBloc>().add(StartDiscoverEvent());
  }

  void _connected() {
    context.read<ConnectedDeviceBloc>().add(DoConnectedEvent());
    // context.read<ConnectedDeviceBloc>().add(IsConnectedEvent());
    context.dismissDialog();
    context.pop();
  }

  Future<void> _openWifiSettings() async {

    final navigator = Navigator.of(context);

    final intent = const AndroidIntent(
      action: 'android.settings.WIFI_SETTINGS',
    );

    await intent.launch();

    ConnectivityUtil.connectivityStream().listen((hasInternet) {
      log("hasInternet: $hasInternet");
      if (hasInternet) {
        navigator.pop();
      } 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(textTitle: "Find Device"),
      body: BlocConsumer<FindDeviceBloc, FindDeviceState>(
        listener: (context, state) {
          if (state is InitializedState) {
            _startDiscover();
            _peers = [];
            log("initialized");
          } else if (state is ScanResultState) {
            _peers = state.peers;
          } else if (state is ConnectingState) {
            context.showLoading();
          } else if (state is ConnectedState) {
            log("is connected?");
            _connected();
          }
          else if (state is ErrorState) {
            context.showStatus(
              title: 'Oops', 
              description: 'Please enable your WiFi', 
              buttonTitle: "Continue",
              onButtonPressed: _openWifiSettings,
            );
          }
        },
        builder: (context, state) {

          return Container(
            color: CustomColors.gray.withValues(alpha: 0.2),
            child: Stack(
              alignment: Alignment.topCenter,
              clipBehavior: Clip.none,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 200.0),
                  alignment: Alignment.center,
                  child: BluetoothRadar(
                    deviceCount: results.length,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: DeviceList(peers: _peers),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
