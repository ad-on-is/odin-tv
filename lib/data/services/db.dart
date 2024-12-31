import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

class DB extends StateNotifier<bool> {
  LazyBox? hive;
  CollectionBox? users;
  final Ref ref;
  DB(this.ref) : super(false);
}

final dbProvider = StateNotifierProvider((ref) => DB(ref));
