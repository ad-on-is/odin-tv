import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odin/data/entities/imdb.dart';
import 'package:odin/data/services/api.dart';
import 'package:odin/helpers.dart';

import 'db.dart';

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
