import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odin/data/entities/imdb.dart';
import 'package:odin/data/services/api.dart';
import 'package:odin/helpers.dart';

class ImdbService extends StateNotifier<bool> with BaseHelper {
  final ApiService api;
  Imdb? imdb;

  ImdbService(this.api) : super(false);

  Future<void> getReviews(String id) async {
    var res = await api.get("/-/imdb/$id");
    imdb = res.match((l) => Imdb(), (r) => Imdb.fromJson(r));

    state = !state;
  }
}

final imdbProvider = StateNotifierProvider.autoDispose(
    (ref) => ImdbService(ref.watch(apiProvider)));
