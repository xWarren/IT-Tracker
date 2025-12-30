import 'package:flutter/material.dart';

import '../../../core/common/common_image.dart';
import '../../../core/resources/assets.dart';
import '../../../core/resources/colors.dart';
import '../../../core/resources/dimensions.dart';

class WaitingContent extends StatelessWidget {
  const WaitingContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CommonImage(
          path: Assets.waiting,
          height: 196.0,
          width: 196.0,
        ),
        SizedBox(height: Dimensions.spacingMedium),
        Text(
          "Waiting for sender",
          style: TextStyle(
            color: CustomColors.black,
            fontSize: 16.0,
            fontWeight: FontWeight.w600
          ),
        ),
        Text(
          "Please keep this screen open while\nwe prepare the transfer.",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: CustomColors.gray,
            fontSize: 14.0,
            fontWeight: FontWeight.w400
          ),
        )
      ],
    );
  }
}