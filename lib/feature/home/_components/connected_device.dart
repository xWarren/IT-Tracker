import 'package:flutter/material.dart';

import '../../../core/resources/colors.dart';
import '../../../core/resources/dimensions.dart';

class ConnectedDevice extends StatelessWidget {
  const ConnectedDevice({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Dimensions.paddingMedium),
      margin: const EdgeInsets.symmetric(horizontal: Dimensions.marginMedium),
      decoration: BoxDecoration(
        color: CustomColors.white,
        borderRadius: BorderRadius.circular(
          Dimensions.radiusExtraSmall,
        ),
        border: Border.all(
          color: CustomColors.gray,
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Connected Device",
            style: TextStyle(
              color: CustomColors.black,
              fontSize: 16.0,
              fontWeight: FontWeight.w600
            ),
          ),
          const SizedBox(height: Dimensions.spacingMedium),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: Dimensions.spacingSmall,
            children: [
              const Expanded(
                child: Text(
                  "Android V2",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: CustomColors.primary,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500
                  ),
                ),
              ),
              RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: "Meter Counter: ",
                      style: TextStyle(
                        color: CustomColors.black,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400
                      ),
                    ),
                    TextSpan(
                      text: "12 Meters",
                      style: TextStyle(
                        color: CustomColors.tertiary,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}