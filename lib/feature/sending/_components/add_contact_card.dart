import 'package:flutter/material.dart';

import '../../../core/common/common_elevated_button.dart';
import '../../../core/common/common_icon_button.dart';
import '../../../core/common/common_image.dart';
import '../../../core/resources/assets.dart';
import '../../../core/resources/colors.dart';
import '../../../core/resources/dimensions.dart';
import '../../../core/utils/context_extension.dart';

class AddContactCard extends StatelessWidget {
  const AddContactCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.screenWidth,
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
          const Text(
            "Contact",
            style: TextStyle(
              color: CustomColors.primary,
              fontSize: 16.0,
              fontWeight: FontWeight.w500
            ),
          ),
          Row(
            spacing: Dimensions.spacingSmall,
            children: [
              const CommonImage(
                path: Assets.logo2,
                height: 36.0,
                width: 36.0,
              ),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Android V2",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: CustomColors.black,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600
                      ),
                    ),
                    Text(
                      "androidv2@gmail.com",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: CustomColors.black,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600
                      ),
                    )
                  ],
                ),
              ),
              CommonElevatedButton(
                onButtonPressed: () {},
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSmall),
                borderRadius: BorderRadiusGeometry.circular(Dimensions.radiusSmall),
                custom: Row(
                  children: [
                    CommonIconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.add,
                        size: 24.0,
                        color: CustomColors.white,
                      ),
                    ),
                    const Text(
                      "Add Contact",
                      style: TextStyle(
                        color: CustomColors.white,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}