import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/common/common_icon_button.dart';
import '../../core/resources/colors.dart';
import '../../core/resources/dimensions.dart';
import '../../core/utils/context_extension.dart';
import '../../core/utils/device_info_util.dart';
import '../edit_profile/bloc/get_profile/get_profile_bloc.dart';
import '_components/general_card.dart';
// import '_components/logout_card.dart';
import '_components/profile_card.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  String? deviceName;

  @override
  void initState() {
    super.initState();
    _loadDeviceInfo();
    _getProfile();
  }

  Future<void> _loadDeviceInfo() async {
    final name = await DeviceInfoUtil.getDeviceName();
    setState(() {
      deviceName = name;
    });
  }

  void _getProfile() => context.read<GetProfileBloc>().add(DoGetProfileEvent());

  @override
  Widget build(BuildContext context) {
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
                height: 200 + 100 + (4 * 100),
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.topCenter,
                  children: [
                    Container(
                      height: 150,
                      padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.paddingMedium,
                        vertical: Dimensions.paddingLarge
                      ),
                      width: context.screenWidth,
                      color: CustomColors.primary,
                      child: Container(
                        alignment: Alignment.topCenter,
                        padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingMedium),
                        child: Row(
                          spacing: Dimensions.spacingSmall,
                          children: [
                            CommonIconButton(
                              rippleColor: Colors.transparent,
                              backgroundColor: Colors.transparent,
                              onPressed: context.pop,
                              icon: const Icon(
                                Icons.arrow_back,
                                size: 24.0,
                                color: CustomColors.white
                              ),
                            ),
                            const Text(
                              "Settings",
                              style: TextStyle(
                                color: CustomColors.white,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500
                              ),
                            ),
                          ]
                        ),
                      )
                    ),
                    Positioned(
                      top: 90,
                      left: 0,
                      right: 0,
                      child: Column(
                        spacing: Dimensions.spacingMedium,
                        children: [
                          ProfileCard(deviceName: deviceName ?? ""),
                          const GeneralCard(),
                          // const LogoutCard(),
                          const Text(
                            "Version 1.0.0",
                            style: TextStyle(
                              color: CustomColors.black,
                              fontSize: 12.0,
                              fontWeight: FontWeight.w400
                            ),
                          )
                        ]
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}