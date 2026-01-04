import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../../resources/colors.dart';
import '../../resources/dimensions.dart';
import '../context_extension.dart';

class AvailableDevicesBottomsheet extends StatefulWidget {

  const AvailableDevicesBottomsheet({super.key, required this.results});

  final List<ScanResult> results;

  @override
  State<AvailableDevicesBottomsheet> createState() => _AvailableDevicesBottomsheetState();
}

class _AvailableDevicesBottomsheetState extends State<AvailableDevicesBottomsheet> {

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.screenWidth,
      padding: const EdgeInsets.all(Dimensions.paddingMedium),
      decoration: const BoxDecoration(
        color: CustomColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(Dimensions.radiusMedium),
          topRight: Radius.circular(Dimensions.radiusMedium)
        )
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: Dimensions.spacingExtraSmall),
            Align(
              child: Container(
                height: 7.0,
                width: 46.0,
                decoration: BoxDecoration(
                  color: CustomColors.tertiary,
                  borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge)
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Available Devices (${widget.results.length})",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Expanded(
              child: ListView.separated(
                itemCount: widget.results.length,
                separatorBuilder: (_, _) =>
                    const Divider(height: 1),
                itemBuilder: (context, index) {
                  final result = widget.results[index];
                  final device = result.device;

                  return ListTile(
                    title: Text(
                      device.platformName.isNotEmpty
                          ? device.platformName
                          : "Unknown Device",
                    ),
                    trailing: const Icon(
                      Icons.chevron_right,
                    ),
                    onTap: () {
                      // Connect or navigate
                    },
                  );
                },
              ),
            ),
            SizedBox(height: context.screenBottom),
          ],
        ),
      ),
    );
  }
}