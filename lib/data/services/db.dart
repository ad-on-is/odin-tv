import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:odin/helpers.dart';

class DB with BaseHelper {
  final HiveBox hive;
  final Ref ref;

  DB(this.ref, this.hive);

  void save(String key, dynamic object) async {
    try {
      await hive.cached?.put(
          key, {'time': DateTime.now().millisecondsSinceEpoch, 'data': object});
    } catch (e, s) {
      logError('$key: $e', s);
    }
  }

  Future<dynamic> get(String key, int seconds) async {
    try {
      var cache = await hive.cached?.get(key);
      if (cache != null &&
          cache['time'] >
              DateTime.now().millisecondsSinceEpoch - (seconds * 1000)) {
        return cache['data'];
      }
      return null;
    } catch (e, s) {
      logError(e, s);
      return null;
    }
  }
}

class HiveBox {
  LazyBox? hive;
  LazyBox? cached;
  final Ref ref;
  HiveBox(this.ref);
}

final hiveProvider = Provider((ref) => HiveBox(ref));

final dbProvider = Provider((ref) => DB(ref, ref.watch(hiveProvider)));
