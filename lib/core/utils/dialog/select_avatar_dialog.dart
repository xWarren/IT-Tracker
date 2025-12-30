import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';

import '../../common/common_elevated_button.dart';
import '../../common/common_icon_button.dart';
import '../../common/common_image.dart';
import '../../resources/assets.dart';
import '../../resources/colors.dart';
import '../../resources/dimensions.dart';
import '../asset_file_util.dart';
import '../context_extension.dart';
import '../image_picker_util.dart';

class SelectAvatarDialog extends StatefulWidget {

  const SelectAvatarDialog({super.key, required this.onSelectedCallBack});

  final Function(File? file) onSelectedCallBack;

  @override
  State<SelectAvatarDialog> createState() => _SelectAvatarDialogState();
}

class _SelectAvatarDialogState extends State<SelectAvatarDialog> {

  List<String> avatars = [
    Assets.avatar1,
    Assets.avatar2,
    Assets.avatar3,
    Assets.avatar4,
    Assets.avatar5,
    Assets.avatar6,
    Assets.avatar7,
    Assets.avatar8,
    Assets.avatar9,
    Assets.avatar10,
  ];

  String _avatarSelected = "";

  File? _file;


  void _setSelectedAvatar(String avatar) async {
    log("avatar: $avatar");

    final file = await AssetFileUtil.assetToFile(avatar);

    setState(() {
      _avatarSelected = avatar;
      _file = null;
    });

    widget.onSelectedCallBack(file);
  }

  void _uploadImage() async {
    final file = await ImagePickerUtil.pickImageFromGallery();

    if (file != null) {
      setState(() {
        _avatarSelected = "";
        _file = file;
      });

      widget.onSelectedCallBack(file);
    }
  }
  

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: CustomColors.white,
      insetPadding: const EdgeInsets.all(Dimensions.paddingMedium),
      shape: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Dimensions.radiusMedium),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(Dimensions.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
            const Text(
              "Select Avatar",
              style: TextStyle(
                color: CustomColors.black,
                fontSize: 16.0,
                fontWeight: FontWeight.w600
              ),
            ),
            const SizedBox(height: Dimensions.spacingSmall),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
              itemCount: avatars.length,
              itemBuilder: (context, index) {
                final isSelected = _avatarSelected == avatars[index].toString();
                return GestureDetector(
                  onTap: () => _setSelectedAvatar(avatars[index].toString()),
                  child: Stack(
                    alignment: Alignment.topCenter,
                    clipBehavior: Clip.none,
                    children: [
                      CommonImage(
                        path: avatars[index],
                        height: 46.0,
                        width: 46.0,
                        radius: 99.0,
                      ),
                      if (isSelected)
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: CustomColors.primary,
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(2),
                          child: const Icon(
                            Icons.check,
                            size: 14,
                            color: CustomColors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: Dimensions.spacingMedium),
            const Text(
              "Upload Picture",
              style: TextStyle(
                color: CustomColors.black,
                fontSize: 16.0,
                fontWeight: FontWeight.w600
              ),
            ),
            const SizedBox(height: Dimensions.spacingSmall),
            GestureDetector(
              onTap: _uploadImage,
              child: Container(
                alignment: Alignment.center,
                height: 40.0,
                width: context.screenWidth,
                decoration: BoxDecoration(
                  color: CustomColors.white,
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  border: Border.all(color: CustomColors.primary)
                ),
                child: Text(
                  _file == null
                  ? "Upload Image"
                  : _file!.path.split('/').last,
                  style: const TextStyle(
                    color: CustomColors.primary,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600
                  ),
                ),
              ),
            ),
            const SizedBox(height: Dimensions.spacingLarge),
            SizedBox(
              height: 40.0,
              width: context.screenWidth,
              child: CommonElevatedButton(
                onButtonPressed: context.dismissBottomSheet,
                text: "Continue",
              ),
            ),
          ],
        ),
      ),
    );
  }
}