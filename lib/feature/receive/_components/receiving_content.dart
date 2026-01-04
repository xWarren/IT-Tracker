import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:nearby_service/nearby_service.dart';

import '../../../core/common/common_elevated_button.dart';
import '../../../core/common/common_image.dart';
import '../../../core/resources/assets.dart';
import '../../../core/resources/colors.dart';
import '../../../core/resources/dimensions.dart';
import '../../../core/utils/context_extension.dart';
// import '../../sending/_components/add_contact_card.dart';

class ReceivingContent extends StatelessWidget {

  const ReceivingContent({
    super.key, 
    required this.stopDiscover,
    required this.progress,
    required this.filesInfo,
    required this.deviceName
  });

  final VoidCallback stopDiscover;
  final double progress;
  final List<NearbyFileInfo> filesInfo;
  final String deviceName;


  @override
  Widget build(BuildContext context) {
    return _ReceivingView(
      progress: progress, 
      filesInfo: filesInfo,
      deviceName: deviceName,
      stopDiscover: stopDiscover
    );
  }
}


class _ReceivingView extends StatelessWidget {
  final double progress;
  final List<NearbyFileInfo> filesInfo;
  final String deviceName;
  final VoidCallback stopDiscover;

  const _ReceivingView({
    required this.progress, 
    required this.filesInfo,
    required this.deviceName,
    required this.stopDiscover
  });

  @override
  Widget build(BuildContext context) {
    log("Asdhasdhas ${filesInfo.length}");
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: Dimensions.spacingMedium),

          const Center(
            child: Text(
              "Receiving",
              style: TextStyle(
                color: CustomColors.black,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          Center(
            child: Text(
              "from $deviceName",
              style: const TextStyle(
                color: CustomColors.gray,
                fontSize: 14,
              ),
            ),
          ),

          const SizedBox(height: Dimensions.spacingSmall),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingMedium),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filesInfo.length,
              itemBuilder: (context, index) {
                final item = filesInfo[index];
                return Row(
                  children: [
                    const CommonImage(
                      path: Assets.logo2,
                      height: 46,
                      width: 46,
                      radius: 99,
                    ),
                    const SizedBox(width: Dimensions.spacingSmall),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                item.name,
                                style: const TextStyle(
                                  color: CustomColors.primary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                "${(progress * 100).toInt()}%",
                                style: const TextStyle(
                                  color: CustomColors.primary,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          LinearProgressIndicator(
                            value: progress,
                            minHeight: 6,
                            backgroundColor:
                                CustomColors.gray.withValues(alpha: 0.2),
                            valueColor: const AlwaysStoppedAnimation(
                              CustomColors.tertiary,
                            ),
                            borderRadius:
                                BorderRadius.circular(Dimensions.radiusMedium),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
              separatorBuilder: (_, _) => const SizedBox(height: 8),
            ),
          ),

          const SizedBox(height: Dimensions.spacingMedium),
          // const AddContactCard(),
          const SizedBox(height: Dimensions.spacingMedium),

          Container(
            height: 50,
            width: context.screenWidth,
            margin: const EdgeInsets.symmetric(
              horizontal: Dimensions.marginMedium,
              vertical: Dimensions.marginLarge,
            ),
            child: CommonElevatedButton(
              onButtonPressed: progress == 1.0 ? stopDiscover : null,
              text: "Continue",
              borderRadius:
                  BorderRadius.circular(Dimensions.radiusLarge),
            ),
          ),
        ],
      ),
    );
  }
}
