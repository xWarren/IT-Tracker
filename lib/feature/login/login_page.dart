import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/common/common_elevated_button.dart';
import '../../core/common/common_image.dart';
import '../../core/common/common_text_field.dart';
import '../../core/resources/app_routes.dart';
import '../../core/resources/assets.dart';
import '../../core/resources/colors.dart';
import '../../core/resources/dimensions.dart';
import '../../core/utils/context_extension.dart';
import 'bloc/login_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();


  void _login() {
    context.read<LoginBloc>().add(
      DoLoginEvent(
        email: _emailController.text,
        password: _passwordController.text
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: context.dismissKeyboard,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.light,
          statusBarColor: CustomColors.white,
          statusBarIconBrightness: Brightness.dark
        ),
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          body: BlocConsumer<LoginBloc, LoginState>(
            listener: (context, state) {
              if (state is LoadedState) {
                context.go(AppRoutes.home);
              }
            },
            builder: (context, state) {
              return LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: constraints.maxHeight),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CommonImage(
                            path: Assets.logo,
                            height: 96.0,
                            width: 96.0,
                          ),
                          const SizedBox(height: Dimensions.spacingSmall),
                          const Text(
                            "Welcome Back!",
                            style: TextStyle(
                              color: CustomColors.primary,
                              fontSize: 24.0,
                              fontWeight: FontWeight.w500
                            ),
                          ),
                          const SizedBox(height: Dimensions.spacingMedium),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingMedium),
                            child: CommonTextField(
                              controller: _emailController,
                              helperText: "Email",
                              helperTextStyle: const TextStyle(
                                color: CustomColors.black,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w500
                              ),
                              helperPadding: EdgeInsets.zero,
                              hintText: "test@gmail.com",
                              hintTextStyle: const TextStyle(
                                color: CustomColors.gray,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w400
                              ),
                              inputBorder: const UnderlineInputBorder(borderSide: BorderSide(color: CustomColors.gray)),
                            ),
                          ),
                          const SizedBox(height: Dimensions.spacingSmall),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingMedium),
                            child: CommonTextField(
                              controller: _passwordController,
                              helperText: "Password",
                              helperTextStyle: const TextStyle(
                                color: CustomColors.black,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w500
                              ),
                              helperPadding: EdgeInsets.zero,
                              hintText: "*******",
                              hintTextStyle: const TextStyle(
                                color: CustomColors.gray,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w400
                              ),
                              inputBorder: const UnderlineInputBorder(borderSide: BorderSide(color: CustomColors.gray)),
                              hasShowHideTextIcon: true,
                              maxLines: 1,
                            ),
                          ),
                          const SizedBox(height: Dimensions.spacingExtraLarge),
                          Container(
                            height: 50.0,
                            width: context.screenWidth,
                            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingMedium),
                            child: CommonElevatedButton(
                              onButtonPressed: _login,
                              text: "Login",
                            ),
                          ),
                          const SizedBox(height: Dimensions.spacingExtraLarge),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            spacing: Dimensions.spacingExtraSmall,
                            children: [
                              const Text(
                                "Create an account?",
                                style: TextStyle(
                                  color: CustomColors.black,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w400
                                ),
                              ),
                              GestureDetector(
                                onTap: () => context.push(AppRoutes.register),
                                child: const Text(
                                  "Register",
                                  style: TextStyle(
                                    color: CustomColors.primary,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w600
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: Dimensions.spacingExtraLarge),
                        ],
                      ),
                    ),
                  );
                }
              );
            }
          ),
        ),
      ),
    );
  }
}