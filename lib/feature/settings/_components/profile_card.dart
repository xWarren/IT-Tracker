import 'package:flutter/material.dart';

import '../../../core/common/common_image.dart';
import '../../../core/resources/assets.dart';
import '../../../core/resources/colors.dart';
import '../../../core/resources/dimensions.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key, required this.deviceName});

  final String deviceName;

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
      child: Row(
        spacing: Dimensions.spacingMedium,
        children: [
          const CommonImage(
            path: Assets.logo2,
            height: 68.0,
            width: 68.0,
            fit: BoxFit.fill,
            radius: 99.0,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Android V2",
                  style: TextStyle(
                    color: CustomColors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600
                  ),
                ),
                Text(
                  "Device Name: $deviceName",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: CustomColors.black,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}