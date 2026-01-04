import 'package:flutter/material.dart';

import '../../resources/colors.dart';
import '../../resources/dimensions.dart';

class LoadingDialog extends StatelessWidget {
  const LoadingDialog({super.key});

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
        child: Container(
          alignment: Alignment.center,
          height: 56.0,
          width: 56.0,
          child: const Text(
            "Loading...",
            style: TextStyle(
              color: CustomColors.black,
              fontSize: 14.0,
              fontWeight: FontWeight.w500
            ),
          ),
        ),
      ),
    );
  }
}