import 'package:flutter/material.dart';

import '../../../core/common/common_elevated_button.dart';
import '../../../core/common/common_image.dart';
import '../../../core/resources/assets.dart';
import '../../../core/resources/colors.dart';
import '../../../core/resources/dimensions.dart';
import '../../../core/utils/context_extension.dart';

class LogoutCard extends StatelessWidget {
  const LogoutCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Dimensions.paddingMedium),
      child: CommonElevatedButton(
        onButtonPressed: context.showStatus,
        backgroundColor: Colors.white,
        padding: const EdgeInsets.all(Dimensions.paddingMedium),
        borderRadius: BorderRadiusGeometry.circular(Dimensions.radiusExtraSmall),
        borderSide: const BorderSide(
          color: CustomColors.gray,
          width: 0.5
        ),
        custom: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              spacing: Dimensions.spacingSmall,
              children: [
                CommonImage(
                  path: Assets.logout,
                  height: 24.0,
                  width: 24.0,
                  fit: BoxFit.fill,
                ),
                Text(
                  "Log Out",
                  style: TextStyle(
                    color: CustomColors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500
                  ),
                ),
                Spacer(),
                Icon(
                  Icons.keyboard_arrow_right_rounded,
                  size: 32.0,
                  color: CustomColors.gray,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}