import 'package:flutter/material.dart';

import '../../common/common_elevated_button.dart';
import '../../common/common_icon_button.dart';
import '../../resources/colors.dart';
import '../../resources/dimensions.dart';
import '../context_extension.dart';

class AddContactBottomsheet extends StatefulWidget {

  const AddContactBottomsheet({
    super.key,
    required this.profileImage,
    required this.fullName,
    required this.email
  });

  final String profileImage;
  final String fullName;
  final String email;

  @override
  State<AddContactBottomsheet> createState() => _AddContactBottomsheetState();
}

class _AddContactBottomsheetState extends State<AddContactBottomsheet> {

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.screenWidth,
      padding: const EdgeInsets.all(Dimensions.paddingMedium),
      decoration: const BoxDecoration(
        color: CustomColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(Dimensions.radiusMedium),
          topRight: Radius.circular(Dimensions.radiusMedium)
        )
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: Dimensions.spacingExtraSmall),
            Align(
              child: Container(
                height: 7.0,
                width: 46.0,
                decoration: BoxDecoration(
                  color: CustomColors.tertiary,
                  borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge)
                ),
              ),
            ),
            const SizedBox(height: Dimensions.spacingMedium),
            const Align(
              child: Text(
                "Are you sure you want to add?",
                style: TextStyle(
                  color: CustomColors.black,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600
                ),
              ),
            ),
            const SizedBox(height: Dimensions.spacingSmall),
            Align(
              child: CommonIconButton(
                onPressed: () {},
                iconSize: 86.0,
                backgroundColor: CustomColors.primary.withValues(alpha: 0.5),
                borderSideColor: CustomColors.primary.withValues(alpha: 0.5),
                icon: const Icon(
                  Icons.person,
                  color: CustomColors.white,
                  size: 56.0,
                ),
              ),
            ),
            const SizedBox(height: Dimensions.spacingSmall),
            Text(
              widget.fullName,
              style: const TextStyle(
                color: CustomColors.black,
                fontSize: 14.0,
                fontWeight: FontWeight.w500
              ),
            ),
            Text(
              widget.email,
              style: const TextStyle(
                color: CustomColors.gray,
                fontSize: 14.0,
                fontWeight: FontWeight.w400
              ),
            ),
            const SizedBox(height: Dimensions.spacingMedium),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              spacing: Dimensions.spacingMedium,
              children: [
                Expanded(
                  child: SizedBox(
                    width: context.screenWidth,
                    child: CommonElevatedButton(
                      onButtonPressed: context.dismissBottomSheet,
                      backgroundColor: CustomColors.tertiary.withValues(alpha: 0.2),
                      borderSide: const BorderSide(color: CustomColors.tertiary),
                      overlayColor: CustomColors.tertiary,
                      text: "Cancel",
                      fontColor: CustomColors.black,
                      fontSize: 14.0,
                    ),
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    width: context.screenWidth,
                    child: CommonElevatedButton(
                      onButtonPressed: () {},
                      borderSide: const BorderSide(color: CustomColors.primary),
                      text: "Yes",
                      fontSize: 14.0,
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: context.sreenBottom),
          ],
        ),
      ),
    );
  }
}