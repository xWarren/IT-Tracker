import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nearby_service/nearby_service.dart';

import '../../core/common/common_appbar.dart';
import '../../core/resources/app_routes.dart';
import '../find_device/bloc/find_device/find_device_bloc.dart';
import '../home/bloc/conneceted_device/connected_device_bloc.dart';
import '_components/receiving_content.dart';
import '_components/waiting_content.dart';
import 'bloc/receive_bloc.dart';

class ReceivePage extends StatefulWidget {
  const ReceivePage({super.key});

  @override
  State<ReceivePage> createState() => _ReceivePageState();
}

class _ReceivePageState extends State<ReceivePage> {

  final _pageController = PageController();

  double progress = 0.0;
  final List<NearbyFileInfo> filesInfo = [];
  String deviceName = "";

  void _nextPage() {
    _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.bounceIn);
  }

  void _stopDiscover() {
    context.read<FindDeviceBloc>().add(StopDiscoverEvent());
    _disconnect();
  }
  

  void _disconnect() {
    context.read<ConnectedDeviceBloc>().add(DoDisconnectEvent());
    context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReceiveBloc, ReceiveState>(
      listener: (context, state) {
        log("state. $state");
        if (state is ReceiveFileRequesting) {
          log("ReceiveFileRequesting: asdsada");
          _nextPage();
          deviceName = state.deviceName;
          filesInfo.addAll(state.filesInfo);
          if (filesInfo.isNotEmpty) {
            log("?filesInfo: ${filesInfo.length} ${filesInfo.first.name} ${filesInfo.first.path} $deviceName");
          }
        } else if (state is ReceiveFileInProgress) {
          progress = state.progress.toDouble()   ;
        }
        else if (state is ReceiveFileSuccess) {
          progress = 1.0;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: CommonAppBar(textTitle: "Receive"),
          body: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              const WaitingContent(),
              ReceivingContent(
                stopDiscover: _stopDiscover,
                progress: progress,
                filesInfo: filesInfo,
                deviceName: deviceName,
              )
            ],
          ),
        );
      }
    );
  }
}