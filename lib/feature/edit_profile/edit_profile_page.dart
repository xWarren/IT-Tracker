import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/common/common_appbar.dart';
import '../../core/common/common_elevated_button.dart';
import '../../core/common/common_icon_button.dart';
import '../../core/common/common_text_field.dart';
import '../../core/resources/app_routes.dart';
import '../../core/resources/colors.dart';
import '../../core/resources/dimensions.dart';
import '../../core/utils/context_extension.dart';
import '../../core/utils/input_formatters.dart';
import '../home/bloc/profile/profile_bloc.dart' as profile;
import 'bloc/get_profile/get_profile_bloc.dart';
import 'bloc/set_profile_2/set_profile_2_bloc.dart' as setprofile;

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {

  final _nameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  
  String _profilePicture = "";

  File? _file;

  @override
  void initState() {
    super.initState();
    _getProfile();
  }

  void _getProfile() => context.read<GetProfileBloc>().add(DoGetProfileEvent());
  void _getProfile2() => context.read<profile.ProfileBloc>().add(profile.DoGetProfileEvent());

  void _setProfile() {
    context.read<setprofile.SetProfile2Bloc>().add(
      setprofile.DoSetProfileEvent(
        file: _file, 
        name: _nameController.text, 
        phoneNumber: _phoneNumberController.text
      )
    );
  }

  @override
  void dispose() {
    _file = null;
    _nameController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: context.dismissKeyboard,
      child: Scaffold(
        appBar: CommonAppBar(textTitle: "Edit Profile"),
        body: BlocConsumer<GetProfileBloc, GetProfileState>(
          listener: (context, state) {
            if (state is LoadedState) {
              _nameController.text = state.name;
              _phoneNumberController.text = state.phoneNumber;
              _profilePicture = state.file;
            }
          },
          builder: (context, state) {
            log("State $state");
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingMedium),
              child: Column(
                children: [
                  const SizedBox(height: Dimensions.spacingLarge),
                  Align(
                    child: CommonIconButton(
                      onPressed: () {
                        log("Asdahsndh");
                        context.showSelectAvatar(
                          (file) {
                            setState(() {
                              _file = file;
                              _profilePicture = "";
                            });
                          }
                        );
                      },
                      iconSize: 86.0,
                      backgroundColor: CustomColors.white,
                      borderSideColor: CustomColors.primary.withValues(alpha: 0.5),
                      icon: _file != null
                      ? ClipOval(
                        child: Image.file(
                          _file!,
                          width: 56,
                          height: 56,
                          fit: BoxFit.cover,
                        ),
                      )
                      : _profilePicture.isNotEmpty
                      ? ClipOval(
                        child: Image.file(
                          File(_profilePicture),
                          width: 56,
                          height: 56,
                          fit: BoxFit.cover,
                        ),
                      )
                      : const Icon(
                        Icons.person,
                        color: CustomColors.white,
                        size: 56.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: Dimensions.spacingMedium),
                  CommonTextField(
                    controller: _nameController,
                    helperText: "Name",
                    helperTextStyle: const TextStyle(
                      color: CustomColors.black,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500
                    ),
                    maxLines: 1,
                    helperPadding: EdgeInsets.zero,
                    hintText: "Enter your name...",
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
                    controller: _phoneNumberController,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.phone,
                    inputFormatters: InputFormatters.contactPhone,
                    helperText: "Phone Number",
                    helperTextStyle: const TextStyle(
                      color: CustomColors.black,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500
                    ),
                    maxLines: 1,
                    helperPadding: EdgeInsets.zero,
                    hintText: "Enter your phone number...",
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
                ],
              ),
            );
      
          }
        ),
        bottomSheet: BlocConsumer<setprofile.SetProfile2Bloc, setprofile.SetProfile2State>(
          listener: (context, state) {
            if (state is setprofile.LoadedState) {
              _getProfile();
              _getProfile2();
              context.go(AppRoutes.home);
            }
          },
          builder: (context, state) {
            return Container(
              height: 50.0,
              margin: EdgeInsets.symmetric(
                horizontal: Dimensions.marginMedium,
                vertical: context.screenBottom + 56.0
              ),
              width: context.screenWidth,
              child: CommonElevatedButton(
                onButtonPressed: (_nameController.text.isNotEmpty && _phoneNumberController.text.isNotEmpty) ? _setProfile : null,
                text: "Update",
              ),
            );
          }
        )
      ),
    );
  }
}