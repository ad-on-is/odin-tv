import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:odin/helpers.dart';

class DB {
  LazyBox? hive;
  final Ref ref;
  DB(this.ref);
}

final dbProvider = Provider((ref) => DB(ref));
