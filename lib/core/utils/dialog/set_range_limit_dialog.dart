import 'dart:developer';

import 'package:flutter/material.dart';

import '../../../di/shared_preferences_manager.dart';
import '../../common/common_elevated_button.dart';
import '../../common/common_icon_button.dart';
import '../../common/common_text_field.dart';
import '../../cubit/range_limit_cubit.dart';
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

  late final RangeLimitCubit _cubit;

  @override
  void initState() {
    super.initState();
    _initCubit();();
  }

   void _initCubit() async {
    final prefs = await SharedPreferencesManager.getInstance();
    _cubit = RangeLimitCubit(prefs);

    // Initialize text controllers with saved values
    for (final value in _cubit.state) {
      _rangeLimitControllers.add(TextEditingController(text: value.toString()));
    }

    if (_rangeLimitControllers.isEmpty) {
      _addField();
    }

    setState(() {});
  }


 void _addField() {
    final controller = TextEditingController();
    _rangeLimitControllers.add(controller);
    _cubit.addRange(0);
    setState(() {});
  }

  void _removeField(int index) {
    _rangeLimitControllers[index].dispose();
    _rangeLimitControllers.removeAt(index);
    _cubit.removeRangeAt(index);
    setState(() {});
  }

  @override
  void dispose() {
    for (final controller in _rangeLimitControllers) {
      controller.dispose();
    }
    _cubit.close();
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
                        onPressed: _rangeLimitControllers.length > 1 ? () => _removeField(index) : null,
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
                  onButtonPressed: _addField,
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
                onButtonPressed: () async {
                  for (int i = 0; i < _rangeLimitControllers.length; i++) {
                    final value = int.tryParse(_rangeLimitControllers[i].text) ?? 0;
                    _cubit.updateRange(i, value);
                  }
                  
                  await _cubit.save();

                  log("Saved ranges: ${_cubit.state}");

                  context.dismissBottomSheet();
                },
                text: "Save",
              ),
            ),
          ],
        ),
      ),
    );
  }
}