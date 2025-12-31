import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/common/common_icon_button.dart';
import '../../../core/resources/app_routes.dart';
import '../../../core/resources/colors.dart';
import '../../../core/resources/dimensions.dart';

class OnlineMenu extends StatelessWidget {
  const OnlineMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: Dimensions.spacingSmall,
      children: [
        CommonIconButton(
          onPressed: () => context.push(AppRoutes.editProfile),
          backgroundColor: CustomColors.white,
          icon: Container(
            height: 24.0,
            width: 24.0,
            decoration: const BoxDecoration(
              color: CustomColors.white,
              shape: BoxShape.circle
            ),
          )
        ),
        CommonIconButton(
          onPressed: () => context.push(AppRoutes.chat),
          backgroundColor: Colors.transparent,
          rippleColor: Colors.transparent,
          icon: const Icon(
            Icons.message,
            color: CustomColors.white,
          ),
        ),
        CommonIconButton(
          onPressed: () => context.push(AppRoutes.settings),
          backgroundColor: Colors.transparent,
          rippleColor: Colors.transparent,
          icon: const Icon(
            Icons.settings,
            color: CustomColors.white,
          ),
        )
      ],
    );
  }
}