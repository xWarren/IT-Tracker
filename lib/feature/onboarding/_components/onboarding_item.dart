import 'package:flutter/material.dart';

import '../../../core/common/common_image.dart';
import '../../../core/resources/colors.dart';
import '../../../core/resources/dimensions.dart';

class OnboardingItem extends StatelessWidget {

  const OnboardingItem({
    super.key,
    required this.image,
    required this.title,
    required this.description
  });

  final String image;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CommonImage(
            path: image,
            height: 210.0,
            width: 210.0,
            fit: BoxFit.fill
        ),
        const SizedBox(height: Dimensions.spacingLarge),
        RichText(
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          text: TextSpan(
            children: _buildStyledTitle(title),
          ),
        ),
        const SizedBox(height: Dimensions.spacingMedium),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingMedium),
          child: Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: CustomColors.gray,
                fontSize: 14.0,
                fontWeight: FontWeight.w400
            ),
          ),
        )
      ],
    );
  }

  List<TextSpan> _buildStyledTitle(String title) {
    const highlights = ['I', 'Tracker', 'Conversation', 'Alerts'];
    return title.split(' ').map((word) {
      final isHighlighted = highlights.contains(word);
      return TextSpan(
        text: '$word ',
        style: TextStyle(
            color: isHighlighted ? CustomColors.primary : CustomColors.black,
            fontSize: 20.0,
            fontWeight: FontWeight.w600
        ),
      );
    }).toList();
  }
}