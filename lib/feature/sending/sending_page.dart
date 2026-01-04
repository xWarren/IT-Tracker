import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/common/common_appbar.dart';
import '../../core/common/common_divider.dart';
import '../../core/common/common_elevated_button.dart';
import '../../core/common/common_image.dart';
import '../../core/resources/app_routes.dart';
import '../../core/resources/assets.dart';
import '../../core/resources/colors.dart';
import '../../core/resources/dimensions.dart';
import '../../core/utils/context_extension.dart';
import '../find_device/bloc/find_device/find_device_bloc.dart';
import '../home/bloc/conneceted_device/connected_device_bloc.dart';
// import '_components/add_contact_card.dart';

class SendingPage extends StatefulWidget {
  
  const SendingPage({
    super.key,
    required this.deviceName,
  });

  final String deviceName;

  @override
  State<SendingPage> createState() => _SendingPageState();
}

class _SendingPageState extends State<SendingPage> {

  double progress = 0.0;

  @override
  void initState() {
    super.initState();
    _startDownloading();
  }

  void _startDownloading() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 300));
      if (progress >= 1.0) return false;

      setState(() {
        progress += 0.05;
      });
      return true;
    });
  }

  void _stopDiscover() {
    context.read<FindDeviceBloc>().add(StopDiscoverEvent());
    _disconnect();
  }
  

  void _disconnect() {
    context.read<ConnectedDeviceBloc>().add(DoDisconnectEvent());
    context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(textTitle: "Sending"),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: Dimensions.spacingMedium),
            const Center(
              child: Text(
                "Sending",
                style: TextStyle(
                  color: CustomColors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600
                ),
              ),
            ),
            Center(
              child: Text(
                "to ${widget.deviceName}",
                style: const TextStyle(
                  color: CustomColors.gray,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w400
                ),
              ),
            ),
            const SizedBox(height: Dimensions.spacingSmall),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingMedium),
              child: ListView.separated(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 1,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSmall),
                    child: Row(
                      spacing: Dimensions.spacingSmall,
                      children: [
                        const CommonImage(
                          path: Assets.logo2,
                          height: 46.0,
                          width: 46.0,
                          radius: 99.0,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "base",
                                    style: TextStyle(
                                      color: CustomColors.primary,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w500
                                    ),
                                  ),
                                  Text(
                                    "${(progress * 100).toInt()} %",
                                    style: const TextStyle(
                                      color: CustomColors.primary,
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w500
                                    ),
                                  ),
                                ],
                              ),
                              LinearProgressIndicator(
                                value: progress,
                                minHeight: 6,
                                backgroundColor: CustomColors.gray.withValues(alpha: 0.2),
                                valueColor: const AlwaysStoppedAnimation(CustomColors.tertiary),
                                borderRadius: BorderRadius.circular(Dimensions.radiusMedium),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    height: 0,
                    child: CommonDivider(),
                  );
                },
              ),
            ),
            const SizedBox(height: Dimensions.spacingMedium),
            // const AddContactCard(),
            const SizedBox(height: 100.0),
          ],
        ),
      ),
      bottomSheet: Container(
        height: 50.0,
        width: context.screenWidth,
        margin: EdgeInsets.symmetric(
          horizontal: Dimensions.marginMedium,
          vertical: context.screenBottom + Dimensions.marginMedium
        ),
        child: CommonElevatedButton(
          onButtonPressed: (progress * 100).toInt() == 100 ? _stopDiscover : null ,
          text: "Continue",
          borderRadius: BorderRadiusGeometry.circular(Dimensions.radiusLarge),
        ),
      ),
    );
  }
}