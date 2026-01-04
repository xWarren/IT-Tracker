import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:go_router/go_router.dart';

import 'bottomsheet/add_contact_bottomsheet.dart';
import 'bottomsheet/available_devices_bottomsheet.dart';
import 'bottomsheet/set_up_your_profile_bottomsheet.dart';
import 'bottomsheet/logout_bottomsheet.dart';
import 'dialog/loading_dialog.dart';
import 'dialog/select_avatar_dialog.dart';
import 'dialog/set_range_limit_dialog.dart';
import 'dialog/status_dialog.dart';

extension ContextExt on BuildContext {

  double get screenWidth => MediaQuery.of(this).size.width;

  double get screenHeight => MediaQuery.of(this).size.height;

  double get screenBottom => MediaQuery.of(this).viewInsets.bottom + MediaQuery.of(this).viewPadding.bottom;

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

  void showAddContact({
    required String profileImage, 
    required String fullName,
    required String email
  }) {
    showModalBottomSheet(
      context: this, 
      builder: (_) {
        return AddContactBottomsheet(
          profileImage: profileImage,
          fullName: fullName,
          email: email
        );
      }
    );
  }

  void showLogout() {
    showModalBottomSheet(
      context: this,
      builder: (_) {
        return const LogOutBottomsheet();
      }
    );
  }

  void showAvailableDevices({required List<ScanResult> results}) {
    showModalBottomSheet(
      context: this,
      builder: (_) {
        return AvailableDevicesBottomsheet(results: results);
      }
    );
  }

  void showSelectAvatar(Function(File? file) onSelectedCallBack) {
    showDialog(
      context: this,
      builder: (_) {
        return SelectAvatarDialog(onSelectedCallBack: onSelectedCallBack);
      }
    );
  }

  void showSetRangeLimit() {
    showDialog(
      context: this,
      builder: (_) {
        return const SetRangeLimitDialog();
      }
    );
  }

  void showLoading() {
    showDialog(
      context: this,
      barrierDismissible: false,
      builder: (_) {
        return const LoadingDialog();
      }
    );
  }

  void showStatus({
    required String title,
    required String description,
    required String buttonTitle,
    required VoidCallback onButtonPressed,
    String? buttonTitle2,
    VoidCallback? onButtonPressed2
  }) {
    showDialog(
      context: this,
      barrierDismissible: false,
      builder: (_) {
        return StatusDialog(
          title: title,
          description: description,
          buttonTitle: buttonTitle,
          onButtonPressed: onButtonPressed,
          buttonTitle2: buttonTitle2,
          onButtonPressed2: onButtonPressed2
        );
      }
    );
  }
}