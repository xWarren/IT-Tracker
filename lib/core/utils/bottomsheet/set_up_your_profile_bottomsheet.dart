import 'dart:io';

import 'package:flutter/material.dart';

import '../../common/common_elevated_button.dart';
import '../../common/common_icon_button.dart';
import '../../common/common_image.dart';
import '../../common/common_text_field.dart';
import '../../resources/colors.dart';
import '../../resources/dimensions.dart';
import '../context_extension.dart';
import '../input_formatters.dart';

class SetUpYourProfileBottomsheet extends StatefulWidget {
  const SetUpYourProfileBottomsheet({super.key});

  @override
  State<SetUpYourProfileBottomsheet> createState() => _SetUpYourProfileBottomsheetState();
}

class _SetUpYourProfileBottomsheetState extends State<SetUpYourProfileBottomsheet> {

  final _nameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  

  File? _file;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

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
          crossAxisAlignment: CrossAxisAlignment.start,
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
                "Set Up Your Profile",
                style: TextStyle(
                  color: CustomColors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600
                ),
              ),
            ),
            const SizedBox(height: Dimensions.spacingSmall),
            const Text(
              "Profile Picture",
              style: TextStyle(
                color: CustomColors.black,
                fontSize: 14.0,
                fontWeight: FontWeight.w500
              ),
            ),
            Align(
              child: CommonIconButton(
                onPressed: () {
                  context.showSelectAvatar(
                    (file) {
                      setState(() {
                        _file = file;
                      });
                    }
                  );
                },
                iconSize: 86.0,
                backgroundColor: CustomColors.primary.withValues(alpha: 0.5),
                borderSideColor: CustomColors.primary.withValues(alpha: 0.5),
                icon: _file?.path.isEmpty ?? true 
                ?const Icon(
                  Icons.person,
                  color: CustomColors.white,
                  size: 56.0,
                )
                : CommonImage(
                  file: _file,
                  height: 86.0,
                  width: 86.0,
                  radius: 99.0,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            const SizedBox(height: Dimensions.spacingSmall),
            CommonTextField(
              controller: _nameController,
              helperText: "Name",
              helperTextStyle: const TextStyle(
                color: CustomColors.black,
                fontSize: 14.0,
                fontWeight: FontWeight.w500
              ),
              maxLines: 1,
              helperPadding: EdgeInsets.zero,
              hintText: "Enter your name...",
              hintTextStyle: const TextStyle(
                color: CustomColors.gray,
                fontSize: 14.0,
                fontWeight: FontWeight.w400
              ),
              inputBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                borderSide: const BorderSide(color: CustomColors.gray)
              ),
            ),
            const SizedBox(height: Dimensions.spacingSmall),
            CommonTextField(
              controller: _nameController,
              helperText: "Phone Number",
              inputFormatters: InputFormatters.contactPhone,
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.phone,
              helperTextStyle: const TextStyle(
                color: CustomColors.black,
                fontSize: 14.0,
                fontWeight: FontWeight.w500
              ),
              maxLines: 1,
              helperPadding: EdgeInsets.zero,
              hintText: "Enter your phone number...",
              hintTextStyle: const TextStyle(
                color: CustomColors.gray,
                fontSize: 14.0,
                fontWeight: FontWeight.w400
              ),
              inputBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                borderSide: const BorderSide(color: CustomColors.gray)
              ),
            ),
            const SizedBox(height: Dimensions.spacingExtraLarge),
            SizedBox(
              height: 50.0,
              width: context.screenWidth,
              child: CommonElevatedButton(
                onButtonPressed: context.dismissBottomSheet,
                text: "Save",
              ),
            ),
            SizedBox(height: context.sreenBottom),
          ],
        ),
      ),
    );
  }
}