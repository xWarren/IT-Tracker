import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:go_router/go_router.dart';

import '../../../core/common/common_elevated_button.dart';
import '../../../core/common/common_icon_button.dart';
import '../../../core/resources/app_routes.dart';
import '../../../core/resources/colors.dart';
import '../../../core/resources/dimensions.dart';
import '../../../core/utils/context_extension.dart';

class FindDevice extends StatefulWidget {
  const FindDevice({super.key});

  @override
  State<FindDevice> createState() => _FindDeviceState();
}

class _FindDeviceState extends State<FindDevice> {

  bool _isTurnOn = false;


  @override
  void initState() {
    super.initState();
    _checkBluetoothStatus();
  }

  void _turnOn() async {
    // FlutterBluePlus.startScan(
    //   timeout: const Duration(seconds: 10),
    //   androidUsesFineLocation: true,
    // );\

    final state = await FlutterBluePlus.adapterState.first;

    if (state != BluetoothAdapterState.on) {
      await FlutterBluePlus.turnOn();
      _goToFindDevice();
    }

    setState(() {
      _isTurnOn = true;
    });
  }
  
  void _goToFindDevice() => context.push(AppRoutes.findDevice);

  void _checkBluetoothStatus() async {
    FlutterBluePlus.adapterState.listen((state) {
      if (state == BluetoothAdapterState.on) {
        log("Bluetooth is ON");
        setState(() {
          _isTurnOn = true;
        });
      } else if (state == BluetoothAdapterState.off) {
        log("Bluetooth is OFF");
        setState(() {
          _isTurnOn = false;
        });
      }
    });
  }

  void _openBluetoothSettings() async {
    final intent = const AndroidIntent(
      action: 'android.settings.BLUETOOTH_SETTINGS',
    );
    intent.launch();
  }


  @override
  Widget build(BuildContext context) {
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
                onPressed: () {},
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
              onButtonPressed: _isTurnOn ? _openBluetoothSettings : _turnOn,
              backgroundColor: _isTurnOn ? CustomColors.white : CustomColors.primary,
              borderSide: BorderSide(color: _isTurnOn ? CustomColors.primary : CustomColors.white),
              overlayColor: CustomColors.white,
              text: _isTurnOn ? "Disconnect" : "Connect",
              fontSize: 14.0,
              fontColor: _isTurnOn ? CustomColors.primary : CustomColors.white,
            ),
          ),
        ],
      ),
    );
  }
}