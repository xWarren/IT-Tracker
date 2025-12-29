import 'package:flutter/material.dart';
import '../resources/colors.dart';
import 'common_image.dart';

class CommonIconButton extends StatelessWidget {
  const CommonIconButton({
    super.key,
    this.asset,
    this.icon,
    this.onPressed,
    this.backgroundColor,
    this.rippleColor,
    this.iconSize,
    this.margin,
    this.padding,
    this.borderSideColor = Colors.transparent,
    this.isLoading = false,
  });

  final Color? backgroundColor;
  final Color? rippleColor;
  final String? asset;
  final Widget? icon;
  final double? iconSize;
  final VoidCallback? onPressed;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Color borderSideColor;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final double size = iconSize ?? 35;

    return Container(
      margin: margin,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: Material(
        color: backgroundColor ?? CustomColors.primary,
        shape: CircleBorder(side: BorderSide(color: borderSideColor)),
        child: InkWell(
          splashColor: rippleColor ?? Colors.black12,
          onTap: isLoading ? null : onPressed,
          customBorder: const CircleBorder(),
          child: Ink(
            width: size,
            height: size,
            decoration: const BoxDecoration(shape: BoxShape.circle),
            padding: padding,
            child: Center(
              child: isLoading
                  ? SizedBox(
                width: size * 0.5,
                height: size * 0.5,
                child: const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.white,
                  ),
                  strokeWidth: 2,
                ),
              )
                  : icon ??
                  CommonImage(
                      path: asset ?? "",
                      width: size * 0.6,
                      height: size * 0.6
                  ),
            ),
          ),
        ),
      ),
    );
  }
}