import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/common/common_appbar.dart';
import '../../core/common/common_elevated_button.dart';
import '../../core/common/common_text_field.dart';
import '../../core/resources/app_routes.dart';
import '../../core/resources/colors.dart';
import '../../core/resources/dimensions.dart';
import '../../core/utils/context_extension.dart';
import 'bloc/register_bloc.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _register() {
    context.read<RegisterBloc>().add(
      DoRegisterEvent(
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
    return Scaffold(
      appBar: CommonAppBar(textTitle: "Register"),
      body: BlocConsumer<RegisterBloc, RegisterState>(
        listener: (context, state) {
          if (state is LoadedState) {
            context.go(AppRoutes.home);
            log("asdhasdhashd");
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: Dimensions.spacingLarge),
                const Text(
                  "Create Account",
                  style: TextStyle(
                    color: CustomColors.black,
                    fontSize: 24.0,
                    fontWeight: FontWeight.w600
                  ),
                ),
                const SizedBox(height: Dimensions.spacingMedium),
                CommonTextField(
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
                  inputBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    borderSide: const BorderSide(color: CustomColors.gray)
                  ),
                ),
                const SizedBox(height: Dimensions.spacingSmall),
                CommonTextField(
                  controller: _passwordController,
                  hasShowHideTextIcon: true,
                  maxLines: 1,
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
                  inputBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    borderSide: const BorderSide(color: CustomColors.gray)
                  ),
                ),
                const SizedBox(height: Dimensions.spacingExtraLarge),
                SizedBox(
                  height: 50.0,
                  width: context.screenWidth,
                  child: CommonElevatedButton(
                    onButtonPressed: _register,
                    text: "Register",
                  ),
                ),
              ],
            ),
          );
        }
      ),
    );
  }
}