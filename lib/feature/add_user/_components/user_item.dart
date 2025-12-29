import 'package:flutter/material.dart';

import '../../../core/common/common_elevated_button.dart';
import '../../../core/common/common_image.dart';
import '../../../core/resources/assets.dart';
import '../../../core/resources/colors.dart';
import '../../../core/resources/dimensions.dart';

class UserItem extends StatelessWidget {
  const UserItem({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonElevatedButton(
      onButtonPressed: () {},
      backgroundColor: Colors.white,
      borderRadius: BorderRadius.zero,
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.paddingMedium,
        vertical: Dimensions.paddingSmall
      ),
      custom: const Row(
        children: [
          CommonImage(
            path: Assets.logo2,
            height: 36.0,
            width: 36.0,
            fit: BoxFit.fill,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Zenki",
                  style: TextStyle(
                    color: CustomColors.black,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600
                  ),
                ),
                Text(
                  "zenki@gmail.com",
                  style: TextStyle(
                      color: CustomColors.black,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
