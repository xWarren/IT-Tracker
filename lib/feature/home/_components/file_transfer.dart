import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/common/common_elevated_button.dart';
import '../../../core/common/common_image.dart';
import '../../../core/resources/app_routes.dart';
import '../../../core/resources/assets.dart';
import '../../../core/resources/colors.dart';
import '../../../core/resources/dimensions.dart';
import '../../../core/utils/context_extension.dart';

class FileTransfer extends StatelessWidget {
  const FileTransfer({super.key});

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
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "File Transfer",
            style: TextStyle(
              color: CustomColors.black,
              fontSize: 16.0,
              fontWeight: FontWeight.w600
            ),
          ),
          const Text(
            "Share files, images, videos & documents",
            style: TextStyle(
              color: CustomColors.gray,
              fontSize: 12.0,
              fontWeight: FontWeight.w400
            ),
          ),
          const SizedBox(height: Dimensions.spacingMedium),
          Row(
            spacing: Dimensions.spacingMedium,
            children: [
              Expanded(
                child: SizedBox(
                  height: 50.0,
                  width: context.screenWidth,
                  child: CommonElevatedButton(
                    onButtonPressed: () => context.push(AppRoutes.sendFile),
                    overlayColor: CustomColors.secondary,
                    backgroundColor: CustomColors.secondary.withValues(alpha: 0.2),
                    borderSide: const BorderSide(color: CustomColors.secondary),
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSmall),
                    custom: Row(
                      spacing: Dimensions.spacingExtraSmall,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(Dimensions.paddingSmall),
                          margin: const EdgeInsets.symmetric(vertical: Dimensions.marginExtraSmall),
                          decoration: const BoxDecoration(
                            color: CustomColors.secondary,
                            shape: BoxShape.circle
                          ),
                          child: const CommonImage(
                            path: Assets.send,
                            height: 20.0,
                            width: 20.0,
                          )
                        ),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Send File",
                                style: TextStyle(
                                  color: CustomColors.black,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w500
                                ),
                              ),
                              Text(
                                "Import",
                                style: TextStyle(
                                  color: CustomColors.gray,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w400
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: SizedBox(
                  height: 50.0,
                  width: context.screenWidth,
                  child: CommonElevatedButton(
                    onButtonPressed: () => context.push(AppRoutes.receive),
                    overlayColor: CustomColors.tertiary,
                    backgroundColor: CustomColors.tertiary.withValues(alpha: 0.2),
                    borderSide: const BorderSide(color: CustomColors.tertiary),
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSmall),
                    custom: Row(
                      spacing: Dimensions.spacingExtraSmall,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(Dimensions.paddingSmall),
                          margin: const EdgeInsets.symmetric(vertical: Dimensions.marginExtraSmall),
                          decoration: const BoxDecoration(
                            color: CustomColors.tertiary,
                            shape: BoxShape.circle
                          ),
                          child: const CommonImage(
                            path: Assets.documentDownload,
                            height: 20.0,
                            width: 20.0,
                          )
                        ),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Receive",
                                style: TextStyle(
                                  color: CustomColors.black,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w500
                                ),
                              ),
                              Text(
                                "Export",
                                style: TextStyle(
                                  color: CustomColors.gray,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w400
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}