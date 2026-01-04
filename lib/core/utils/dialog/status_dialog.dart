import 'package:flutter/material.dart';

import '../../common/common_elevated_button.dart';
import '../../common/common_icon_button.dart';
import '../../resources/colors.dart';
import '../../resources/dimensions.dart';
import '../context_extension.dart';

class StatusDialog extends StatelessWidget {

  const StatusDialog({
    super.key,
    required this.title,
    required this.description,
    required this.buttonTitle,
    required this.onButtonPressed,
    required this.buttonTitle2,
    required this.onButtonPressed2
  });

  final String title;
  final String description;
  final String buttonTitle;
  final VoidCallback onButtonPressed;
  final String? buttonTitle2;
  final VoidCallback? onButtonPressed2;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Dialog(
        elevation: 0,
        backgroundColor: CustomColors.white,
        insetPadding: const EdgeInsets.all(Dimensions.paddingMedium),
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimensions.radiusMedium),
          borderSide: const BorderSide(color: CustomColors.white)
        ),
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.paddingMedium),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: Dimensions.spacingExtraSmall),
              Align(
                alignment: Alignment.topRight,
                child: CommonIconButton(
                  onPressed: context.dismissDialog,
                  backgroundColor: CustomColors.tertiary,
                  iconSize: 26.0,
                  icon: const Icon(
                    Icons.close,
                    color: CustomColors.white,
                    size: 20.0
                  ),
                ),
              ),
              const SizedBox(height: Dimensions.spacingMedium),
              Text(
                title,
                style: const TextStyle(
                  color: CustomColors.black,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600
                ),
              ),
              const SizedBox(height: Dimensions.spacingExtraSmall),
              Text(
                description,
                style: const TextStyle(
                  color: CustomColors.gray,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w400
                ),
              ),
              const SizedBox(height: Dimensions.spacingLarge),
              Row(
                spacing: Dimensions.spacingSmall,
                children: [
                  if (buttonTitle2?.isNotEmpty ?? false)
                  Expanded(
                    child: SizedBox(
                      height: 40.0,
                      width: context.screenWidth,
                      child: CommonElevatedButton(
                        onButtonPressed: onButtonPressed2,
                        backgroundColor: CustomColors.tertiary,
                        text: buttonTitle2,
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 40.0,
                      width: context.screenWidth,
                      child: CommonElevatedButton(
                        onButtonPressed: onButtonPressed,
                        text: buttonTitle,
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}