import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/common/common_icon_button.dart';
import '../../core/resources/app_routes.dart';
import '../../core/resources/assets.dart';
import '../../core/resources/colors.dart';
import '../../core/resources/dimensions.dart';
import '_components/onboarding_item.dart';
import 'bloc/onboarding_bloc.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {

  final _pageController = PageController();

  int _currentIndex = 0;

  final List<Map<String, String>> _onboardings = [
    {
      "image": Assets.download,
      "title": "Welcome to I Tracker",
      "description": "Easily connect with nearby devices and transfer files faster than ever. Tap Send or Receive to get started!"
    },
    {
      "image": Assets.chat,
      "title": "Start a Conversation",
      "description": "Chat instantly with connected devices while sharing files. Send messages, updates, or quick notes in real time."
    },
    {
      "image": Assets.pushNotification,
      "title": "Connection Alerts",
      "description": "Get instant notifications if your connection drops, so you can quickly reconnect and keep sharing."
    },
  ];

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void nextPage() {
    if (_currentIndex != 2) {
      _pageController.nextPage(duration: const Duration(milliseconds: 350), curve: Curves.linear);
    } else {
      _doneOnboarding();
    }
  }

  void backPage() {
    if (_currentIndex != 0) {
      _pageController.previousPage(duration: const Duration(milliseconds: 350), curve: Curves.linear);
    }
  }

  void _doneOnboarding() => context.read<OnboardingBloc>().add(DoneOnboardingEvent());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<OnboardingBloc, OnboardingState>(
        listener: (context, state) {
          if (state is LoadedState) {
            context.go(AppRoutes.termsandconditions);
          }
        },
        builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: PageView.builder(
                  itemCount: _onboardings.length,
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final item = _onboardings[index];
                    return OnboardingItem(
                      image: item['image'] ?? "",
                      title: item['title'] ?? "",
                      description: item['description'] ?? ""
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.paddingMedium,
                  vertical: Dimensions.paddingExtraLarge
                ),
                child: Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    Row(
                      mainAxisAlignment: _currentIndex == 0 ? MainAxisAlignment.end : MainAxisAlignment.spaceBetween,
                      children: [
                        if(_currentIndex != 0)
                          _buildArrowButton(
                            backgroundColor: CustomColors.white,
                            borderSideColor: CustomColors.primary,
                            onPressed: backPage,
                            icon: const Icon(
                              Icons.arrow_back,
                              color: CustomColors.primary
                            ),
                          ),
                        _buildArrowButton(
                          backgroundColor: CustomColors.primary,
                          borderSideColor: CustomColors.primary,
                          onPressed: nextPage,
                          icon: const Icon(
                            Icons.arrow_forward,
                            color: CustomColors.white
                          ),
                        )
                      ],
                    ),
                    _buildCircle()
                  ],
                ),
              )
            ],
          );
        }
      ),
    );
  }

  Widget _buildArrowButton({
    required Color backgroundColor,
    required Color borderSideColor,
    required Widget icon,
    required VoidCallback onPressed
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      child: CommonIconButton(
          backgroundColor: backgroundColor,
          borderSideColor: borderSideColor,
          onPressed: onPressed,
          rippleColor: CustomColors.primary.withAlpha(50),
          icon: icon
      ),
    );
  }

  Widget _buildCircle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_onboardings.length, (index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          alignment: Alignment.center,
          width: index == _currentIndex ? 9.0 : 6.0,
          height: index == _currentIndex ? 9.0 : 6.0,
          margin: const EdgeInsets.symmetric(horizontal: Dimensions.marginExtraSmall),
          decoration: BoxDecoration(
            color: index == _currentIndex ? CustomColors.primary : CustomColors.primary.withAlpha(25),
            shape: BoxShape.circle
          ),
        );
      }),
    );
  }
}