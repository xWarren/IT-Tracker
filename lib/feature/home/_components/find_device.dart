import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:go_router/go_router.dart';

import '../../../core/common/common_elevated_button.dart';
import '../../../core/common/common_icon_button.dart';
import '../../../core/resources/app_routes.dart';
import '../../../core/resources/colors.dart';
import '../../../core/resources/dimensions.dart';
import '../../../core/utils/context_extension.dart';
import '../bloc/conneceted_device/connected_device_bloc.dart';

class FindDevice extends StatefulWidget {

  const FindDevice({super.key, required this.openBluetoothSettings});

  final VoidCallback openBluetoothSettings;

  @override
  State<FindDevice> createState() => _FindDeviceState();
}

class _FindDeviceState extends State<FindDevice> {

  @override
  void initState() {
    super.initState();
    _checkBluetoothStatus();
  }

  void _turnOn() async {

    _goToFindDevice();

    // final state = await FlutterBluePlus.adapterState.first;

    // if (state != BluetoothAdapterState.on) {
    //   await FlutterBluePlus.turnOn();
    //   _goToFindDevice();
    // }
  }
  
  void _goToFindDevice() => context.push(AppRoutes.findDevice);

  void _checkBluetoothStatus() async {
    FlutterBluePlus.adapterState.listen((state) {
      if (state == BluetoothAdapterState.on) {
        log("Bluetooth is ON");
        setState(() {
        });
      } else if (state == BluetoothAdapterState.off) {
        log("Bluetooth is OFF");
        setState(() {
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectedDeviceBloc, ConnectedDeviceState>(
      builder: (context, state) {
        String deviceName = "";

        if (state is LoadedState) {
          deviceName = state.deviceName;
        } else if (state is ErrorState) {
          deviceName = "";
        }

        if (deviceName.isNotEmpty) {
          return const SizedBox.shrink();
        } else {
          return Container(
            padding: const EdgeInsets.all(Dimensions.paddingMedium),
            margin: const EdgeInsets.symmetric(horizontal: Dimensions.marginMedium),
            decoration: BoxDecoration(
              color: CustomColors.white,
              borderRadius: BorderRadius.circular(
                Dimensions.radiusExtraSmall,
              ),
              border: Border.all(
                color: CustomColors.gray,
                width: 0.5,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Find Device",
                          style: TextStyle(
                            color: CustomColors.black,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600
                          ),
                        ),
                        Text(
                          "Connect to your friend",
                          style: TextStyle(
                            color: CustomColors.gray,
                            fontSize: 12.0,
                            fontWeight: FontWeight.w400
                          ),
                        )
                      ],
                    ),
                    CommonIconButton(
                      onPressed: () => context.push(AppRoutes.history),
                      rippleColor: CustomColors.secondary.withValues(alpha: 0.2),
                      backgroundColor: CustomColors.secondary.withValues(alpha: 0.5),
                      icon: const Icon(
                        Icons.notifications,
                        color: CustomColors.secondary,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: Dimensions.spacingMedium),
                SizedBox(
                  height: 40.0,
                  width: context.screenWidth,
                  child: CommonElevatedButton(
                    onButtonPressed: _turnOn,
                    borderSide: const BorderSide(color: CustomColors.white),
                    overlayColor: CustomColors.white,
                    text: "Connect",
                    fontSize: 14.0,
                  ),
                ),
              ],
            ),
          );
        }
      }
    );
  }
}