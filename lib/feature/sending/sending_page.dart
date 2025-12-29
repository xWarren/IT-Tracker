import 'package:flutter/material.dart';

import '../../core/common/common_appbar.dart';
import '../../core/common/common_divider.dart';
import '../../core/common/common_elevated_button.dart';
import '../../core/common/common_image.dart';
import '../../core/resources/assets.dart';
import '../../core/resources/colors.dart';
import '../../core/resources/dimensions.dart';
import '../../core/utils/context_extension.dart';
import '_components/add_contact_card.dart';

class SendingPage extends StatefulWidget {
  const SendingPage({super.key});

  @override
  State<SendingPage> createState() => _SendingPageState();
}

class _SendingPageState extends State<SendingPage> {

  double progress = 0.0;

  @override
  void initState() {
    super.initState();
    _startDownloading();
  }

  void _startDownloading() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 300));
      if (progress >= 1.0) return false;

      setState(() {
        progress += 0.05;
      });
      return true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(textTitle: "Sending"),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: Dimensions.spacingMedium),
            const Center(
              child: Text(
                "Sending",
                style: TextStyle(
                  color: CustomColors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600
                ),
              ),
            ),
            const Center(
              child: Text(
                "to Android V2",
                style: TextStyle(
                  color: CustomColors.gray,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w400
                ),
              ),
            ),
            const SizedBox(height: Dimensions.spacingSmall),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingMedium),
              child: ListView.separated(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSmall),
                    child: Row(
                      spacing: Dimensions.spacingSmall,
                      children: [
                        const CommonImage(
                          path: Assets.logo2,
                          height: 46.0,
                          width: 46.0,
                          radius: 99.0,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Facebook",
                                    style: TextStyle(
                                      color: CustomColors.primary,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w500
                                    ),
                                  ),
                                  Text(
                                    "${(progress * 100).toInt()} %",
                                    style: const TextStyle(
                                      color: CustomColors.primary,
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w500
                                    ),
                                  ),
                                ],
                              ),
                              LinearProgressIndicator(
                                value: progress,
                                minHeight: 6,
                                backgroundColor: CustomColors.gray.withValues(alpha: 0.2),
                                valueColor: const AlwaysStoppedAnimation(CustomColors.tertiary),
                                borderRadius: BorderRadius.circular(Dimensions.radiusMedium),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    height: 0,
                    child: CommonDivider(),
                  );
                },
              ),
            ),
            const SizedBox(height: Dimensions.spacingMedium),
            const AddContactCard(),
            const SizedBox(height: Dimensions.spacingExtraLarge),
          ],
        ),
      ),
      bottomSheet: Container(
        height: 50.0,
        width: context.screenWidth,
        margin: const EdgeInsets.symmetric(
          horizontal: Dimensions.marginMedium,
          vertical: Dimensions.marginLarge
        ),
        child: CommonElevatedButton(
          onButtonPressed: () {},
          text: "Continue",
          borderRadius: BorderRadiusGeometry.circular(Dimensions.radiusLarge),
        ),
      ),
    );
  }
}