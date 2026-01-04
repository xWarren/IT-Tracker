import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/cubit/connectivity_cubit.dart';
import '../core/domain/service/nearby_service.dart';
import '../core/domain/service/notification_service.dart';
import '../core/resources/go_router_refresh.dart';
import '../core/utils/get_it_extension.dart';
import '../feature/conversation/bloc/conversation_bloc.dart';
import '../feature/find_device/bloc/find_device/find_device_bloc.dart';
import '../feature/receive/bloc/receive_bloc.dart';
import '../feature/sending/bloc/sending_bloc.dart';
import 'send_file_history_storage.dart';
import 'shared_preferences_manager.dart';


part 'app.dart';

final getIt = GetIt.I;

Future<void> initDependencies() async {


  // App
  await _initApp();
}