import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/common/common_image.dart';
import '../../../core/resources/colors.dart';
import '../../../core/resources/dimensions.dart';
import '../../edit_profile/bloc/get_profile/get_profile_bloc.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key, required this.deviceName});

  final String deviceName;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetProfileBloc, GetProfileState>(
      builder: (context, state) {
        String _name = "";
        String _profilePicture = "";

        if (state is LoadedState) {
          _name = state.name;
          _profilePicture = state.file;
        }

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
          child: Row(
            spacing: Dimensions.spacingMedium,
            children: [
              _profilePicture.isEmpty
              ? Container(
                height: 68.0,
                width: 68.0,
                decoration: const BoxDecoration(
                  color: CustomColors.white,
                  shape: BoxShape.circle
                ),
              )
              : CommonImage(
                file: File(_profilePicture),
                height: 68.0,
                width: 68.0,
                radius: 99.0,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: CustomColors.black,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600
                      ),
                    ),
                    Text(
                      "Device Name: $deviceName",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: CustomColors.black,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}