import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/common/common_elevated_button.dart';
import '../../../core/common/common_image.dart';
import '../../../core/resources/app_routes.dart';
import '../../../core/resources/assets.dart';
import '../../../core/resources/colors.dart';
import '../../../core/resources/dimensions.dart';

class MessagesItem extends StatelessWidget {
  const MessagesItem({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonElevatedButton(
      onButtonPressed: () => context.push(AppRoutes.conversation),
      backgroundColor: Colors.white,
      borderRadius: BorderRadius.zero,
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.paddingMedium,
        vertical: Dimensions.paddingSmall
      ),
      custom: const Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        spacing: Dimensions.spacingExtraSmall,
        children: [
          CommonImage(
            path: Assets.logo,
            height: 46.0,
            width: 46.0,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Warren Virgines",
                  style: TextStyle(
                    color: CustomColors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500
                  ),
                ),
                Text(
                  "Warren: Hiiiiii",
                  style: TextStyle(
                    color: CustomColors.gray,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400
                  ),
                )
              ],
            ),
          ),
          Text(
            "12:00 AM",
            style: TextStyle(
              color: CustomColors.gray,
              fontSize: 12.0,
              fontWeight: FontWeight.w400
            ),
          )
        ],
      ),
    );
  }
}