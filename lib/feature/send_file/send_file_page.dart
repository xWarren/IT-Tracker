import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/common/common_elevated_button.dart';
import '../../core/resources/app_routes.dart';
import '../../core/resources/colors.dart';
import '../../core/resources/dimensions.dart';
import '../../core/utils/bool_extension.dart';
import '../../core/utils/context_extension.dart';
import '_components/apps_content.dart';
import '_components/files_content.dart';
import '_components/photos_content.dart';
import '_components/send_file_header.dart';
import '_components/videos_content.dart';

class SendFilePage extends StatefulWidget {
  const SendFilePage({super.key});

  @override
  State<SendFilePage> createState() => _SendFilePageState();
}

class _SendFilePageState extends State<SendFilePage> with SingleTickerProviderStateMixin {

  TabController? _tabController;


  bool _isAppSelected = false;
  bool _isPhotoSelected = false;

  final _appsScroll = ScrollController();
  final _filesScroll = ScrollController();
  final _photosScroll = ScrollController();
  final _videosScroll = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController  = TabController(length: 4, vsync: this);
    _tabController?.addListener(() {
      if (!_tabController!.indexIsChanging) {
        _scrollToTop(_tabController!.index);

        setState(() {
          _isAppSelected = _tabController!.index == 0 ? _isAppSelected : false;
          _isPhotoSelected = _tabController!.index == 3 ? _isPhotoSelected : false;
        });
      }
    });
  }

  void _scrollToTop(int index) {
    final controller = switch (index) {
      0 => _appsScroll,
      1 => _filesScroll,
      2 => _photosScroll,
      3 => _videosScroll,
      _ => null,
    };

    if (controller == null) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!controller.hasClients) return;

      controller.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }


  void _setAppCallBack(bool value) => setState(() => _isAppSelected = value);
  void _setPhotosCallBack(bool value) => setState(() => _isPhotoSelected = value);

  void _onTap(int index) {
    setState(() {
      if (index != 0) {
        _isAppSelected = false;
      }
      if (index != 3) {
        _isPhotoSelected = false;
      }
    });
  }

  void _sending() {
    context.push(AppRoutes.sending);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    _appsScroll.dispose();
    _filesScroll.dispose();
    _photosScroll.dispose();
    _videosScroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                    scrollController: _appsScroll,
                  ),
                  FilesContent(scrollController: _filesScroll),
                  VideosContent(scrollController: _videosScroll),
                  PhotosContent(
                    photosCallBack: _setPhotosCallBack,
                    scrollController: _photosScroll,
                  )
                ],
              ),
              Container(
                height: 120,
                width: context.screenWidth,
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingMedium),
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
                          onButtonPressed: _isAppSelected.or(_isPhotoSelected) ? _sending : null,
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
}