import 'package:flutter/material.dart';

import '../../common/common_elevated_button.dart';
import '../../common/common_icon_button.dart';
import '../../common/common_text_field.dart';
import '../../resources/colors.dart';
import '../../resources/dimensions.dart';
import '../context_extension.dart';

class SetRangeLimitDialog extends StatefulWidget {
  const SetRangeLimitDialog({super.key});

  @override
  State<SetRangeLimitDialog> createState() => _SetRangeLimitDialogState();
}

class _SetRangeLimitDialogState extends State<SetRangeLimitDialog> {
  
  final List<TextEditingController> _rangeLimitControllers = <TextEditingController>[];

  @override
  void initState() {
    super.initState();
    _addRangeField(); // start with 1 field
  }

  void _addRangeField() {
    setState(() {
      _rangeLimitControllers.add(TextEditingController());
    });
  }

  void _removeRangeField(int index) {
    setState(() {
      _rangeLimitControllers[index].dispose();
      _rangeLimitControllers.removeAt(index);
    });
  }

  @override
  void dispose() {
    for (final controller in _rangeLimitControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimensions.radiusMedium)
      ),
      surfaceTintColor: Colors.transparent,
      backgroundColor: CustomColors.white,
      insetPadding: const EdgeInsets.all(Dimensions.paddingMedium),
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
              "Set Range Limit",
              style: TextStyle(
                color: CustomColors.black,
                fontSize: 16.0,
                fontWeight: FontWeight.w600
              ),
            ),
            Column(
              children: List.generate(_rangeLimitControllers.length, (index) {
                final item = _rangeLimitControllers[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingExtraSmall),
                  child: Row(
                    children: [
                      Expanded(
                        child: CommonTextField(
                          controller: item,
                          maxLength: 2,
                          hintText: "Range Limit ${index + 1}",
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
                      ),
                      const SizedBox(width: 8),
                      if (_rangeLimitControllers.length > 1)
                      IconButton(
                        onPressed: () => _removeRangeField(index),
                        icon: const Icon(
                          Icons.remove_circle,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                width: 100.0,
                child: CommonElevatedButton(
                  onButtonPressed: _addRangeField,
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingExtraSmall),
                  backgroundColor: CustomColors.secondary.withValues(alpha: 0.2),
                  borderSide: const BorderSide(color: CustomColors.secondary),
                  custom: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: Dimensions.spacingExtraSmall,
                    children: [
                      Icon(
                        Icons.add,
                        size: 20.0,
                        color: CustomColors.secondary,
                      ),
                      Text(
                        "Add Range",
                        style: TextStyle(
                          color: CustomColors.secondary,
                          fontSize: 12.0,
                          fontWeight: FontWeight.w600
                        ),
                      )
                    ],
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