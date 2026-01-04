import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/common/common_appbar.dart';
import '../../core/common/common_divider.dart';
import '../../core/common/common_image.dart';
import '../../core/resources/assets.dart';
import '../../core/resources/colors.dart';
import '../../core/resources/dimensions.dart';
import '../../core/utils/context_extension.dart';
import '../../core/utils/date_time_extension.dart';
import 'bloc/history_bloc.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {


  @override
  void initState() {
    super.initState();
    _getHistory();
  }

  void _getHistory() {
    context.read<HistoryBloc>().add(DoGetHistoryEvent());
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(),
      body: BlocBuilder<HistoryBloc, HistoryState>(
        builder: (context,state) {
          if (state is LoadedState) {
            log("asdhahsdhas ${state.histories.length}");
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: Dimensions.spacingMedium,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.paddingMedium,
                      vertical: Dimensions.paddingSmall
                    ),
                    child: Text(
                      "Recent History",
                      style: TextStyle(
                        color: CustomColors.black,
                        fontSize: 24.0,
                        fontWeight: FontWeight.w600
                      ),
                    ),
                  ),
                  state.histories.isEmpty
                  ? const Padding(
                    padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingMedium),
                    child: Text(
                      "No Recent History",
                      style: TextStyle(
                        color: CustomColors.black,
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500
                      ),
                    ),
                  )
                  : ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemCount: state.histories.length,
                    itemBuilder: (context, index) {
                      final item = state.histories[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Dimensions.paddingMedium,
                          vertical: Dimensions.paddingSmall
                        ),
                        child: Row(
                          spacing: Dimensions.spacingSmall,
                          children: [
                            const CommonImage(
                              path: Assets.logo2,
                              height: 46.0,
                              width: 46.0,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.fileName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: CustomColors.black,
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w600
                                    ),
                                  ),
                                  Text(
                                    "Date: ${item.sentAt.toReadableDateTime()}",
                                    style: const TextStyle(
                                      color: CustomColors.black,
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w600
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        height: 0,
                        child: CommonDivider(),
                      );
                    },
                  ),
                  SizedBox(height: context.screenBottom)
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        }
      ),
    );
  }
}