import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odin/data/entities/imdb.dart';
import 'package:odin/data/services/api.dart';
import 'package:odin/helpers.dart';

import 'db.dart';

Future<Map<String, dynamic>> _parse(String data) async {
  // todo: Exception: RangeError (end): Invalid value: Not in inclusive range 34..3921: -1
  // handle error in imdb.dart
  const start = '<script type="application/ld+json">';
  const end = '</script>';
  final startIndex = data.indexOf(start);
  final endIndex = data.indexOf(end, startIndex + start.length);

  final str = data.substring(startIndex + start.length, endIndex);

  return {
    'string': str,
    'json': jsonDecode(str),
  };
}

class ImdbService extends StateNotifier<bool> with BaseHelper {
  String url = 'https://www.imdb.com/title/';
  final Ref ref;
  final DB db;
  final dio = Dio();
  Imdb? imdb;

  ImdbService(this.ref, this.db) : super(false) {
    dio.options.baseUrl = url;
  }

  Future<void> getReviews(String id) async {
    final api = ref.watch(apiProvider);

    var res = await api.get("/imdb/$id");
    imdb = res.match((l) => Imdb(), (r) => Imdb.fromJson(r));

    state = !state;
  }
}

final imdbProvider = StateNotifierProvider.autoDispose(
    (ref) => ImdbService(ref, ref.watch(dbProvider)));
