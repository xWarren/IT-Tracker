import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../resources/colors.dart';
import 'common_icon_button.dart';

class CommonAppBar extends AppBar{
  CommonAppBar({super.key, this.textTitle, this.titleWidget, this.widget}) : super(
    automaticallyImplyLeading: false,
    elevation: 0.0,
    titleSpacing: 0.0,
    toolbarHeight: 60.0,
    backgroundColor: CustomColors.primary,
    centerTitle: false,
    title: textTitle == null || textTitle.isEmpty
    ? titleWidget
    : Text(
      textTitle,
      style: const TextStyle(
        color: CustomColors.white,
        fontSize: 16.0,
        fontWeight: FontWeight.w500
      ),
    ),
    leading: Builder(
      builder: (context) {
        return CommonIconButton(
          rippleColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          onPressed: context.pop,
          icon: const Icon(
            Icons.arrow_back,
            size: 24.0,
            color: CustomColors.white
          ),
        );
      }
    ),
    actions: widget
  );

  final String? textTitle;
  final Widget? titleWidget;
  final List<Widget>? widget;
}