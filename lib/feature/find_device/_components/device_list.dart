import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nearby_service/nearby_service.dart';

import '../../../core/common/common_divider.dart';
import '../../../core/common/common_elevated_button.dart';
import '../../../core/resources/colors.dart';
import '../../../core/resources/dimensions.dart';
import '../../../core/utils/context_extension.dart';
import '../bloc/find_device/find_device_bloc.dart';

class DeviceList extends StatefulWidget {

  const DeviceList({super.key, required this.peers});

  final List<NearbyDevice> peers;

  @override
  State<DeviceList> createState() => _DeviceListState();
}

class _DeviceListState extends State<DeviceList> {

  void _connect(NearbyDevice device) {
    context.read<FindDeviceBloc>().add(DoConnectEvent(device));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250.0,
      margin: EdgeInsets.only(bottom: context.screenBottom),
      decoration: const BoxDecoration(
        color: CustomColors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: Dimensions.spacingSmall),
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
          const SizedBox(height: Dimensions.spacingMedium),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingMedium),
            child: Text(
              "Available Devices (${widget.peers.length})",
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: Dimensions.spacingSmall),
          Expanded(
            child: ListView.separated(
              itemCount: widget.peers.length,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                final result = widget.peers[index];
                return CommonElevatedButton(
                  onButtonPressed: () => _connect(result),
                  backgroundColor: CustomColors.white,
                  padding: const EdgeInsets.all(Dimensions.paddingMedium),
                  borderRadius: BorderRadius.zero,
                  custom: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        result.info.displayName,
                        style: const TextStyle(
                          color: CustomColors.black,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios_outlined,
                        size: 14.0,
                        color: CustomColors.black,
                      )
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return Container(
                  height: 0,
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingMedium),
                  child: const CommonDivider(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
