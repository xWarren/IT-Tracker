import 'package:flutter/material.dart';

import '../../../core/common/common_icon_button.dart';
import '../../../core/common/common_image.dart';
import '../../../core/resources/assets.dart';
import '../../../core/resources/colors.dart';
import '../../../core/resources/dimensions.dart';

class UserItem extends StatelessWidget {
  const UserItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(Dimensions.marginMedium),
      child: Row(
        spacing: Dimensions.spacingSmall,
        children: [
          const CommonImage(
            path: Assets.logo2,
            height: 36.0,
            width: 36.0,
            fit: BoxFit.fill,
          ),
          const Expanded(
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
          ),
          CommonIconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.add,
              size: 24.0,
              color: CustomColors.white,
            ),
          )
        ],
      ),
    );
  }
}
