import 'package:flutter/material.dart';

import '../resources/colors.dart';

class CommonDivider extends StatelessWidget {

  const CommonDivider({
    super.key,
    this.thickness = 0.5,
    this.color = CustomColors.gray
  });

  final double thickness;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Divider(
        color: color,
        thickness: thickness
    );
  }
}