import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/common/common_elevated_button.dart';
import '../../core/resources/app_routes.dart';
import '../../core/resources/colors.dart';
import '../../core/resources/dimensions.dart';
import '../../core/resources/keys.dart';
import '../../core/utils/bool_extension.dart';
import '../../core/utils/context_extension.dart';
import '_components/apps_content.dart';
import '_components/photos_content.dart';
import '_components/send_file_header.dart';
import 'bloc/send_file_bloc.dart';

class SendFilePage extends StatefulWidget {
  const SendFilePage({super.key});

  @override
  State<SendFilePage> createState() => _SendFilePageState();
}

class _SendFilePageState extends State<SendFilePage> with SingleTickerProviderStateMixin {

  TabController? _tabController;

  List<File> _selectedFiles = [];

  bool _isAppSelected = false;
  bool _isPhotoSelected = false;

  @override
  void initState() {
    super.initState();
    _tabController  = TabController(length: 2, vsync: this);
  }

  void _setAppCallBack(bool value) => setState(() => _isAppSelected = value);
  void _setPhotosCallBack(bool value) => setState(() => _isPhotoSelected = value);

  void _onTap(int index) {
    setState(() {
      if (index != 0) {
        _isAppSelected = false;
      }
      if (index != 1) {
        _isPhotoSelected = false;
      }
    });
  }

  void _sending({required String deviceName}) {
    context.push(
      AppRoutes.sending,
      extra: {
        Keys.deviceNameKey: deviceName
      }
    );
  }

  void _sendFile() {
    context.read<SendFileBloc>().add(SendFilesEvent(_selectedFiles));
  }


  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SendFileBloc, SendFileState>(
      listener: (context, state) {
        if (state is SendFileSending) {
          _sending(deviceName: state.deviceName);
        }
      },
      builder: (context, state) {
        return Material(
          color: CustomColors.white,
          child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverPersistentHeader(
                    pinned: true,
                    floating: true,
                    delegate: SendFileHeader(
                      tabController: _tabController,
                      onButtonPressed: () {},
                      onTap: _onTap
                    ),
                  )
                ];
              },
              body: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  TabBarView(
                    controller: _tabController,
                    children: [
                      AppsContent(
                        appCallBack: _setAppCallBack,
                        onFilesSelected: (files) {
                          setState(() {
                            _selectedFiles = files;
                          });
                        }
                      ),
                      PhotosContent(
                        photosCallBack: _setPhotosCallBack,
                        onPhotosSelected: (files) {
                          setState(() {
                            _selectedFiles = files;
                          });
                        },
                      )
                    ],
                  ),
                  Container(
                    height: 120,
                    width: context.screenWidth,
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingMedium),
                    margin: EdgeInsets.only(bottom: context.screenBottom),
                    decoration: const BoxDecoration(
                      color: CustomColors.white,
                      border: Border(top: BorderSide(color: CustomColors.gray))
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 50.0,
                            width: context.screenWidth,
                            child: CommonElevatedButton(
                              onButtonPressed: _isAppSelected.or(_isPhotoSelected) ? _sendFile : null,
                              text: "Send",
                              borderRadius: BorderRadiusGeometry.circular(Dimensions.radiusLarge),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )
          ),
        );
      }
    );
  }
}