import 'package:flutter/material.dart';

import '../../../core/common/common_elevated_button.dart';
import '../../../core/common/common_image.dart';
import '../../../core/resources/assets.dart';
import '../../../core/resources/colors.dart';
import '../../../core/resources/dimensions.dart';
import '../../../core/utils/context_extension.dart';

class GeneralCard extends StatelessWidget {
  const GeneralCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.screenWidth,
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
        spacing: Dimensions.spacingMedium,
        children: [
          const SizedBox(height: Dimensions.spacingSmall),
          _buildPage(
            onButtonPressed: () {}, 
            image: Assets.userEdit, 
            title: "Edit Profile"
          ),
          _buildPage(
            onButtonPressed: () {}, 
            image: Assets.clock, 
            title: "History"
          ),
          _buildPage(
            onButtonPressed: () {}, 
            image: Assets.notification, 
            title: "Notifications"
          ),
          _buildPage(
            onButtonPressed: () {}, 
            image: Assets.about, 
            title: "About App"
          ),
          const SizedBox(height: Dimensions.spacingSmall),
        ],
      ),
    );
  }

  Widget _buildPage({
    required VoidCallback onButtonPressed,
    required String image,
    required String title,
  }) {
    return CommonElevatedButton(
      onButtonPressed: onButtonPressed,
      backgroundColor: Colors.transparent,
      padding: EdgeInsets.zero,
      borderRadius: BorderRadius.zero,
      custom: Container(
        height: 50.0,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingMedium),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              spacing: Dimensions.spacingSmall,
              children: [
                CommonImage(
                  path: image,
                  height: 24.0,
                  width: 24.0,
                  fit: BoxFit.fill,
                ),
                Text(
                  title,
                  style: const TextStyle(
                    color: CustomColors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500
                  ),
                ),
                const Spacer(),
                const Icon(
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