import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/common/common_elevated_button.dart';
import '../../core/common/common_image.dart';
import '../../core/resources/strings.dart';
import '../../core/resources/app_routes.dart';
import '../../core/resources/assets.dart';
import '../../core/resources/colors.dart';
import '../../core/resources/dimensions.dart';
import 'bloc/terms_and_conditions_bloc.dart';

class TermsAndConditionsPage extends StatefulWidget {
  const TermsAndConditionsPage({super.key});

  @override
  State<TermsAndConditionsPage> createState() => _TermsAndConditionsPageState();
}

class _TermsAndConditionsPageState extends State<TermsAndConditionsPage> {

  bool _isAgree = false;

  void _onChanged(bool? value) {
    setState(() {
      _isAgree = value ?? false;
    });
  }

  void _continue() => context.read<TermsAndConditionsBloc>().add(DoContinueEvent());

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TermsAndConditionsBloc, TermsAndConditionsState>(
      listener: (context, state) {
        if (state is LoadedState) {
          context.go(AppRoutes.login);
        } 
      },
      builder: (context, state) {
        return Material(
          color: CustomColors.primary,
          child: AnnotatedRegion<SystemUiOverlayStyle>(
            value: const SystemUiOverlayStyle(
              statusBarBrightness: Brightness.dark,
              statusBarColor: CustomColors.white,
              statusBarIconBrightness: Brightness.light
            ),
            child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Center(
                        child: CommonImage(
                          path: Assets.logo2,
                          height: 96.0,
                          width: 96.0,
                        ),
                      ),
                      const SizedBox(height: Dimensions.spacingMedium),
                      const Center(
                        child: Text(
                          "Terms and Conditions",
                          style: TextStyle(
                            color: CustomColors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w500
                          ),
                        ),
                      ),
                      const SizedBox(height: Dimensions.spacingSmall),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingMedium),
                        child: Text(
                          "Welcome to IT Tracker!",
                          style: TextStyle(
                            color: CustomColors.white,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600
                          ),
                        ),
                      ),
                      const SizedBox(height: Dimensions.spacingMedium),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingMedium),
                        child: Text(
                          "By using this app, you agree to the following terms:",
                          style: TextStyle(
                            color: CustomColors.white,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w400
                          ),
                        ),
                      ),
                      const SizedBox(height: Dimensions.spacingExtraSmall),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingMedium),
                        child: Text(
                          Strings.terms,
                          style: TextStyle(
                            color: CustomColors.white,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w400
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Checkbox(
                            value: _isAgree,
                            onChanged: _onChanged,
                            activeColor: CustomColors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(Dimensions.radiusExtraSmall)),
                            side: const BorderSide(color: CustomColors.white),
                            checkColor: CustomColors.primary,
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          const Text(
                            "I agree to the Terms and Conditions",
                            style: TextStyle(
                              color: CustomColors.white,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: Dimensions.spacingExtraLarge),
                      Align(
                        child: SizedBox(
                          height: 40.0,
                          width: 180.0,
                          child: CommonElevatedButton(
                            onButtonPressed: _isAgree ? _continue : null,
                            backgroundColor: CustomColors.white,
                            borderRadius: BorderRadiusGeometry.circular(Dimensions.radiusExtraLarge),
                            text: "Continue",
                            fontColor: CustomColors.primary,
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      }
    );
  }
}