import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'bottomsheet/set_up_your_profile_bottomsheet.dart';

extension ContextExt on BuildContext {

  double get screenWidth => MediaQuery.of(this).size.width;

  double get screenHeight => MediaQuery.of(this).size.height;

  double get sreenBottom => MediaQuery.of(this).viewInsets.bottom + MediaQuery.of(this).viewPadding.bottom;

  void nextFocus() => FocusScope.of(this).nextFocus();

  void previousFocus() => FocusScope.of(this).previousFocus();

  void unfocusAll() => FocusScope.of(this).unfocus();

  void dismissKeyboard() {
    final FocusScopeNode currentFocus = FocusScope.of(this);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      currentFocus.unfocus();
    }
  }

  void dismissDialog() {
    Future.delayed(const Duration(seconds: 1));
    if (Navigator.canPop(this)) {
      pop();
    }
  }

  void dismissBottomSheet() {
    if (mounted && Navigator.of(this).canPop()) {
      Navigator.of(this).pop();
    }
  }

  void showSetUpYourProfile() {
    showModalBottomSheet(
      context: this,
      isDismissible: false,
      enableDrag: false,
      builder: (_) {
        return const SetUpYourProfileBottomsheet();
      }
    );
  }
}