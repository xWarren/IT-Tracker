import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/utils/get_it_extension.dart';
import 'shared_preferences_manager.dart';


part 'app.dart';

final getIt = GetIt.I;

Future<void> initDependencies() async {


  // App
  await _initApp();
}