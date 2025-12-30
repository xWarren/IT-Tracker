import 'package:flutter/material.dart';

import '../../core/common/common_appbar.dart';
import '../../core/common/common_elevated_button.dart';
import '../../core/common/common_icon_button.dart';
import '../../core/common/common_text_field.dart';
import '../../core/resources/colors.dart';
import '../../core/resources/dimensions.dart';
import '../../core/utils/context_extension.dart';
import '../../core/utils/input_formatters.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {

  final _nameController = TextEditingController();
  final _phoneNumberController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(textTitle: "Edit Profile"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingMedium),
        child: Column(
          children: [
            const SizedBox(height: Dimensions.spacingLarge),
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
            const SizedBox(height: Dimensions.spacingMedium),
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
              controller: _phoneNumberController,
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.phone,
              inputFormatters: InputFormatters.contactPhone,
              helperText: "Phone Number",
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
            const SizedBox(height: 100.0),
          ],
        ),
      ),
      bottomSheet: Container(
        height: 50.0,
        margin: const EdgeInsets.symmetric(
          horizontal: Dimensions.marginMedium,
          vertical: Dimensions.marginLarge
        ),
        width: context.screenWidth,
        child: CommonElevatedButton(
          onButtonPressed: () {},
          text: "Update",
        ),
      ),
    );
  }
}