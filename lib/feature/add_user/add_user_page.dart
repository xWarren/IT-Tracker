import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/common/common_appbar.dart';
import '../../core/common/common_divider.dart';
import '../../core/common/common_icon_button.dart';
import '../../core/common/common_state.dart';
import '../../core/common/common_text_field.dart';
import '../../core/cubit/connectivity_cubit.dart';
import '../../core/resources/colors.dart';
import '../../core/resources/dimensions.dart';
import '_components/user_item.dart';

class AddUserPage extends StatefulWidget {
  const AddUserPage({super.key});

  @override
  State<AddUserPage> createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {

  final _searchController = TextEditingController();

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
      builder: (context, state) {
        final hasInternet = state is ConnectivityLoaded && state.isConnected;

        return Scaffold(
          appBar: CommonAppBar(
            textTitle: "Add User",
          ),
          body: hasInternet
          ? Scrollbar(
            controller: _scrollController,
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: Dimensions.spacingMedium),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingMedium),
                    child: CommonTextField(
                      controller: _searchController,
                      prefixIcon: const Icon(
                        Icons.search,
                        color: CustomColors.gray,
                      ),
                      inputBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(Dimensions.radiusMedium),
                        borderSide: const BorderSide(color: CustomColors.gray)
                      ),
                      hintText: "Search Email...",
                      hintTextStyle: const TextStyle(
                        color: CustomColors.gray,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400
                      ),
                    ),
                  ),
                  const SizedBox(height: Dimensions.spacingMedium),
                  ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 120,
                    itemBuilder: (context, index) {
                      return const UserItem();
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        height: 0,
                        child: CommonDivider(),
                      );
                    },
                  )
                ],
              ),
            ),
          )
          : const Center(child: CommonState()),
          floatingActionButton: Visibility(
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
        );
      }
    );
  }
}