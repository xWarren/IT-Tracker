import 'package:flutter/material.dart';

import '../../../core/common/common_image.dart';
import '../../../core/resources/assets.dart';
import '../../../core/resources/colors.dart';

class ContactsItem extends StatelessWidget {
  const ContactsItem({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        CommonImage(
          path: Assets.logo2,
          height: 56.0,
          width: 56.0,
          fit: BoxFit.cover,
          radius: 99.0,
        ),
        Text(
          "Zenki",
          style: TextStyle(
            color: CustomColors.tertiary,
            fontSize: 14.0,
            fontWeight: FontWeight.w500
          ),
        )
      ],
    );
  }
}