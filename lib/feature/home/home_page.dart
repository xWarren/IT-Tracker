import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/common/common_icon_button.dart';
import '../../core/resources/app_routes.dart';
import '../../core/resources/colors.dart';
import '../../core/resources/dimensions.dart';
import '../../core/utils/context_extension.dart';
import '_components/connected_device.dart';
import '_components/file_transfer.dart';
import '_components/find_device.dart';
import 'bloc/profile/profile_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  @override
  void initState() {
    super.initState();
    _getProfile();
  }

  void _getProfile() => context.read<ProfileBloc>().add(DoGetProfileEvent());

  @override
  Widget build(BuildContext context) {
    return Material(
      color: CustomColors.white.withValues(alpha: 0.9),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.light,
          statusBarColor: CustomColors.white,
        ),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: SizedBox(
                height: 200 + 100 + (4 * 216),
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.topCenter,
                  children: [
                    BlocConsumer<ProfileBloc, ProfileState>(
                      listener: (context, state) {
                        if (state is LoadedState) {
                        } else if (state is ErrorState) {
                          context.showSetUpYourProfile();
                        }
                      },
                      builder: (context, state) {
                        return Container(
                          height: 200,
                          padding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.paddingMedium,
                            vertical: Dimensions.paddingLarge
                          ),
                          width: context.screenWidth,
                          color: CustomColors.primary,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Welcome to",
                                    style: TextStyle(
                                      color: CustomColors.white,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w400
                                    ),
                                  ),
                                  Text(
                                    "IT Tracker",
                                    style: TextStyle(
                                      color: CustomColors.white,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w600
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                spacing: Dimensions.spacingSmall,
                                children: [
                                  CommonIconButton(
                                    onPressed: () => context.push(AppRoutes.editProfile),
                                    backgroundColor: CustomColors.white,
                                    icon: Container(
                                      height: 24.0,
                                      width: 24.0,
                                      decoration: const BoxDecoration(
                                        color: CustomColors.white,
                                        shape: BoxShape.circle
                                      ),
                                    )
                                  ),
                                  CommonIconButton(
                                    onPressed: () => context.push(AppRoutes.chat),
                                    backgroundColor: Colors.transparent,
                                    rippleColor: Colors.transparent,
                                    icon: const Icon(
                                      Icons.message,
                                      color: CustomColors.white,
                                    ),
                                  ),
                                  CommonIconButton(
                                    onPressed: () => context.push(AppRoutes.settings),
                                    backgroundColor: Colors.transparent,
                                    rippleColor: Colors.transparent,
                                    icon: const Icon(
                                      Icons.settings,
                                      color: CustomColors.white,
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        );
                      }
                    ),
                    const Positioned(
                      top: 150,
                      left: 0,
                      right: 0,
                      child: Column(
                        spacing: Dimensions.spacingMedium,
                        children: [
                          FindDevice(),
                          ConnectedDevice(),
                          FileTransfer()
                        ]
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
