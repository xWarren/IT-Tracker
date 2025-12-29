import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/resources/colors.dart';
import '../../../../core/resources/dimensions.dart';
import '../../../core/common/common_icon_button.dart';

class SendFileHeader extends SliverPersistentHeaderDelegate {

  SendFileHeader({
    required this.tabController,
    required this.onButtonPressed,
    required this.onTap
  });

  final TabController? tabController;
  final VoidCallback onButtonPressed;
  final Function(int index) onTap;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final progress = shrinkOffset / maxExtent;

    return Material(
      color: CustomColors.white,
      child: Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,
        children: [
          AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: CustomColors.primary,
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
            surfaceTintColor: CustomColors.white,
            title: progress >= 0.18
            ? const Text(
              "Send File",
              style: TextStyle(
                color: CustomColors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.w600
              ),
            )
            : const SizedBox.shrink(),
            titleSpacing: 0.0,
            centerTitle: false,
          ),
          if (progress <= 0.18)
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingMedium),
              child: const Text(
                "Send File",
                style: TextStyle(
                  color: CustomColors.white,
                  fontSize: 24.0,
                  fontWeight: FontWeight.w600
                ),
              ),
            ),
          Row(
            children: [
              TabBar(
                controller: tabController,
                isScrollable: true,
                onTap: onTap,
                physics: const NeverScrollableScrollPhysics(),
                overlayColor: const WidgetStatePropertyAll(Colors.transparent),
                indicatorAnimation: TabIndicatorAnimation.elastic,
                tabAlignment: TabAlignment.start,
                indicatorColor: CustomColors.tertiary,
                indicatorSize: TabBarIndicatorSize.label,
                indicatorWeight: 4.0,
                dividerHeight: 0.0,
                labelStyle: const TextStyle(
                  color: CustomColors.white,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w600
                ),
                unselectedLabelStyle: const TextStyle(
                  color: CustomColors.gray,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w400
                ),
                tabs: const [
                  Tab(text: "Apps"),
                  Tab(text: "Files"),
                  Tab(text: "Videos"),
                  Tab(text: "Photos")
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => 170;

  @override
  double get minExtent => 120;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => true;
}