import 'package:flutter/widgets.dart';

import '../resources/assets.dart';
import '../resources/colors.dart';
import '../resources/dimensions.dart';
import 'common_image.dart';

class CommonState extends StatelessWidget {

  const CommonState({
    super.key,
    this.asset = Assets.noConnection,
    this.title = "No Internet Connection",
    this.description = "Please check your connection and try again."
  });

  final String asset;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CommonImage(
          path: asset,
          height: 196.0,
          width: 196.0,
          fit: BoxFit.fill,
        ),
        const SizedBox(height: Dimensions.spacingSmall),
        Text(
          title,
          style: const TextStyle(
            color: CustomColors.black,
            fontSize: 16.0,
            fontWeight: FontWeight.w600
          ),
        ),
        const SizedBox(height: Dimensions.spacingExtraSmall),
        Text(
          description,
          style: const TextStyle(
            color: CustomColors.gray,
            fontSize: 14.0,
            fontWeight: FontWeight.w400
          ),
        )
      ],
    );
  }
}