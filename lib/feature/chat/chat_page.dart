import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/common/common_divider.dart';
import '../../core/common/common_elevated_button.dart';
import '../../core/common/common_icon_button.dart';
import '../../core/common/common_state.dart';
import '../../core/cubit/connectivity_cubit.dart';
import '../../core/resources/app_routes.dart';
import '../../core/resources/colors.dart';
import '../../core/resources/dimensions.dart';
import '../../core/utils/context_extension.dart';
import '_components/contacts_item.dart';
import '_components/messages_item.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  final _scrollController = ScrollController();

  bool _showScrollToTop = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.offset > 160 && !_showScrollToTop) {
      setState(() => _showScrollToTop = true);
    } else if (_scrollController.offset <= 160 && _showScrollToTop) {
      setState(() => _showScrollToTop = false);
    }
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectivityCubit, ConnectivityState>(
      builder: (context,state ) {
        final hasInternet = state is ConnectivityLoaded && state.isConnected;

        return Material(
          color: CustomColors.white,
          child: NestedScrollView(
            controller: _scrollController,
            headerSliverBuilder: (context, isScrolled) {
              return [
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  elevation: 0.0,
                  titleSpacing: 0.0,
                  toolbarHeight: 60.0,
                  backgroundColor: CustomColors.primary,
                  centerTitle: false,
                  title: const Text(
                    "Chat",
                    style: TextStyle(
                      color: CustomColors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500
                    ),
                  ),
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
                  actionsPadding: const EdgeInsets.only(right: Dimensions.paddingMedium),
                  actions: [
                    if (hasInternet)
                    CommonElevatedButton(
                      onButtonPressed: () => context.push(AppRoutes.addUser),
                      backgroundColor: CustomColors.white,
                      borderSide: const BorderSide(color: CustomColors.white),
                      padding: const EdgeInsets.all(Dimensions.paddingSmall),
                      custom: const Row(
                        spacing: Dimensions.spacingExtraSmall,
                        children: [
                          Icon(
                            Icons.person,
                            size: 24.0,
                            color: CustomColors.primary
                          ),
                          Text(
                            "Add User",
                            style: TextStyle(
                              color: CustomColors.primary,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w600
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                  bottom: hasInternet
                  ? PreferredSize(
                    preferredSize: const Size.fromHeight(90.0),
                    child: Padding(
                      padding: const EdgeInsets.all(Dimensions.paddingMedium),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              height: 50.0,
                              width: context.screenWidth,
                              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingMedium),
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(Dimensions.radiusMedium),
                                border: Border.all(color: CustomColors.white)
                              ),
                              child: const Row(
                                spacing: Dimensions.spacingSmall,
                                children: [
                                  Icon(
                                    Icons.search,
                                    color: CustomColors.white,
                                  ),
                                  Text(
                                    "Search Email...",
                                    style: TextStyle(
                                      color: CustomColors.white,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w400
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                  : null
                )
              ];
            },
            body: hasInternet
            ? Stack(
              alignment: Alignment.bottomRight,
              clipBehavior: Clip.none,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: Dimensions.spacingMedium),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: Dimensions.spacingMedium,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: Dimensions.paddingMedium),
                          child: Text(
                            "Contacts",
                            style: TextStyle(
                              color: CustomColors.black,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 80.0,
                          child: ListView.separated(
                            padding: const EdgeInsets.only(left: Dimensions.paddingMedium),
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: 20,
                            itemBuilder: (context, index) {
                              return const ContactsItem();
                            },
                            separatorBuilder: (context, index) {
                              return const SizedBox(width: Dimensions.spacingMedium);
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: Dimensions.spacingMedium),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: Dimensions.spacingMedium,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: Dimensions.paddingMedium),
                            child: Text(
                              "Messages",
                              style: TextStyle(
                                color: CustomColors.black,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600
                              ),
                            ),
                          ),
                          Expanded(
                            child: Scrollbar(
                              controller: _scrollController,
                              child: ListView.separated(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: 250,
                                itemBuilder: (context, index) {
                                  return const MessagesItem();
                                },
                                separatorBuilder: (context, index) {
                                  return const SizedBox(
                                    height: 0,
                                    child: CommonDivider(),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Positioned(
                  right: 16,
                  bottom: 24,
                  child: Visibility(
                    visible: _showScrollToTop || hasInternet,
                    child: AnimatedSlide(
                      offset: _showScrollToTop ? Offset.zero : const Offset(0, 0.3),
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOut,
                      child: AnimatedOpacity(
                        opacity: _showScrollToTop ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 200),
                        child: IgnorePointer(
                          ignoring: !_showScrollToTop,
                          child: CommonIconButton(
                            onPressed: _scrollToTop,
                            backgroundColor: CustomColors.secondary,
                            icon: const Icon(
                              Icons.arrow_upward,
                              color: CustomColors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
            : const CommonState()
          ),
        );
      }
    );
  }
}