import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/domain/entity/send_file_history_entity.dart';

class SendFileHistoryStorage {
  static const _key = 'send_file_history';

  Future<void> saveFiles(List<SentFileHistoryEntity> files) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = await getHistory();

    final updated = [...files, ...existing];

    final jsonList = updated.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList(_key, jsonList);
  }

  Future<List<SentFileHistoryEntity>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_key) ?? [];

    return jsonList
        .map((e) => SentFileHistoryEntity.fromJson(jsonDecode(e)))
        .toList();
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
