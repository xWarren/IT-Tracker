import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../common/common_elevated_button.dart';
import '../../resources/app_routes.dart';
import '../../resources/colors.dart';
import '../../resources/dimensions.dart';
import '../context_extension.dart';

class StatusBottomsheet extends StatefulWidget {
  const StatusBottomsheet({super.key});

  @override
  State<StatusBottomsheet> createState() => _StatusBottomsheetState();
}

class _StatusBottomsheetState extends State<StatusBottomsheet> {

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
                "Are you sure you want to log out?",
                style: TextStyle(
                  color: CustomColors.black,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600
                ),
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
                      onButtonPressed: () => context.go(AppRoutes.login),
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