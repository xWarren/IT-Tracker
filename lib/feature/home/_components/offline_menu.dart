import 'package:flutter/material.dart';

import '../../../core/common/common_icon_button.dart';
import '../../../core/common/common_image.dart';
import '../../../core/resources/assets.dart';
import '../../../core/resources/colors.dart';
import '../../../core/utils/context_extension.dart';

class OfflineMenu extends StatelessWidget {
  const OfflineMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonIconButton(
      onPressed: context.showLogout,
      icon: const CommonImage(
        path: Assets.logout,
        height: 24.0,
        width: 24.0,
        color: CustomColors.white,
      )
    );
  }
}