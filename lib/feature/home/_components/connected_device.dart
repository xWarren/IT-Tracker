import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/common/common_elevated_button.dart';
import '../../../core/common/common_icon_button.dart';
import '../../../core/common/common_image.dart';
import '../../../core/cubit/connectivity_cubit.dart';
import '../../../core/resources/app_routes.dart';
import '../../../core/resources/assets.dart';
import '../../../core/resources/colors.dart';
import '../../../core/resources/dimensions.dart';
import '../../../core/resources/keys.dart';
import '../../../core/utils/context_extension.dart';
import '../bloc/conneceted_device/connected_device_bloc.dart';

class ConnectedDevice extends StatelessWidget {

  const ConnectedDevice({super.key, required this.disconnect});

  final VoidCallback disconnect;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectivityCubit, ConnectivityState>(
      builder: (context, state) {
        // final hasInternet = state is ConnectivityLoaded && state.isConnected;

        return BlocBuilder<ConnectedDeviceBloc, ConnectedDeviceState>(
          builder: (context, state) {
            double distance = -1;
            String id = "";
            String deviceName = "";

            if (state is LoadedState) {
              distance = state.distance;
              id = state.id;
              deviceName = state.deviceName;
            } else if (state is ErrorState) {
              deviceName = "";
            }

            if (deviceName.isEmpty) {
              return const SizedBox.shrink();
            } else {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.bounceIn,
                padding: const EdgeInsets.all(Dimensions.paddingMedium),
                margin: const EdgeInsets.symmetric(horizontal: Dimensions.marginMedium),
                decoration: BoxDecoration(
                  color: CustomColors.white,
                  borderRadius: BorderRadius.circular(Dimensions.radiusExtraSmall),
                  border: Border.all(
                    color: CustomColors.gray,
                    width: 0.5,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      spacing: Dimensions.spacingSmall,
                      children: [
                        const Text(
                          "Connected Device",
                          style: TextStyle(
                            color: CustomColors.black,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                          CommonIconButton(
                            onPressed: () {
                              context.push(
                                AppRoutes.conversation,
                                extra: {
                                  Keys.deviceIdKey: id,
                                  Keys.deviceNameKey: deviceName,
                                },
                              );
                            },
                            rippleColor: CustomColors.secondary.withValues(alpha: 0.2),
                            backgroundColor: CustomColors.secondary.withValues(alpha: 0.5),
                            icon: const Icon(
                              Icons.message,
                              color: CustomColors.secondary,
                              size: 20.0
                            )
                          ),
                        CommonIconButton(
                          onPressed: context.showSetRangeLimit,
                          rippleColor: CustomColors.secondary.withValues(alpha: 0.2),
                          backgroundColor: CustomColors.secondary.withValues(alpha: 0.5),
                          icon: const CommonImage(
                            path: Assets.ruler,
                            height: 24.0,
                            width: 24.0,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: Dimensions.spacingMedium),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      
                      children: [
                        Text(
                          id.isEmpty ? "Unkown ID" : "Device ID: $id",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: CustomColors.primary,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          deviceName.isEmpty ? "Device Name: Unkown Device" : "Device Name: $deviceName",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: CustomColors.primary,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            children: [
                              const TextSpan(
                                text: "Distance: ",
                                style: TextStyle(
                                  color: CustomColors.black,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              TextSpan(
                                text: distance >= 0 ? "${distance.toStringAsFixed(2)} m" : "0 m",
                                style: const TextStyle(
                                  color: CustomColors.tertiary,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: Dimensions.spacingSmall),
                    SizedBox(
                      height: 40.0,
                      width: context.screenWidth,
                      child: CommonElevatedButton(
                        onButtonPressed: () => disconnect(),
                        backgroundColor: CustomColors.white,
                        borderSide: const BorderSide(color: CustomColors.primary),
                        overlayColor: CustomColors.white,
                        text: "Disconnect",
                        fontSize: 14.0,
                        fontColor: CustomColors.primary,
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        );
      },
    );
  }
}
