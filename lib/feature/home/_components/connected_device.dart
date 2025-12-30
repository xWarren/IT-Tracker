import 'package:flutter/material.dart';

import '../../../core/common/common_icon_button.dart';
import '../../../core/common/common_image.dart';
import '../../../core/resources/assets.dart';
import '../../../core/resources/colors.dart';
import '../../../core/resources/dimensions.dart';
import '../../../core/utils/context_extension.dart';

class ConnectedDevice extends StatelessWidget {
  const ConnectedDevice({super.key});

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
            spacing: Dimensions.spacingSmall,
            children: [
              const Text(
                "Connected Device",
                style: TextStyle(
                  color: CustomColors.black,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600
                ),
              ),
              const Spacer(),
              CommonIconButton(
                onPressed: () {},
                rippleColor: CustomColors.secondary.withValues(alpha: 0.2),
                backgroundColor: CustomColors.secondary.withValues(alpha: 0.5),
                icon: const CommonImage(
                  path: Assets.microphone,
                  height: 24.0,
                  width: 24.0,
                )
              ),
              CommonIconButton(
                onPressed: context.showSetRangeLimit,
                rippleColor: CustomColors.secondary.withValues(alpha: 0.2),
                backgroundColor: CustomColors.secondary.withValues(alpha: 0.5),
                icon: const CommonImage(
                  path: Assets.ruler,
                  height: 24.0,
                  width: 24.0,
                )
              )
            ],
          ),
          const SizedBox(height: Dimensions.spacingMedium),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: Dimensions.spacingSmall,
            children: [
              const Expanded(
                child: Text(
                  "Android V2",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: CustomColors.primary,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500
                  ),
                ),
              ),
              RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: "Meter Counter: ",
                      style: TextStyle(
                        color: CustomColors.black,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400
                      ),
                    ),
                    TextSpan(
                      text: "12 Meters",
                      style: TextStyle(
                        color: CustomColors.tertiary,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}