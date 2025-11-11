import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odin/data/entities/tmdb.dart';
import 'package:odin/data/entities/trakt.dart';
import 'package:odin/data/models/auth_model.dart';
import 'package:odin/data/services/api.dart';
import 'package:odin/helpers.dart';

class TmdbService with BaseHelper {
  String url = 'https://api.themoviedb.org/3';
  String imageURL = 'https://image.tmdb.org/t/p/w500';
  final ApiService api;
  final Ref ref;
  Dio dio = Dio();
  TmdbService(this.ref, this.api);

  Future<Map<int, Map<int, String>>> getEpisodeImages(
      int showId, List<int> seasons) async {
    return (await api
            .get('/-/tmdbseasons/$showId?seasons=${seasons.join(',')}'))
        .match((l) => {}, (r) {
      List<dynamic> list = r;
      Map<int, Map<int, String>> images = {};

      for (var s in List.from(list)) {
        int sn = s['season_number'];
        images[sn] = {};
        Map<int, String> results = {};
        for (var e in s['episodes']) {
          if (e['episode_number'] != null && e['still_path'] != null) {
            int en = e['episode_number'];
            results[en] = e['still_path'];
          }
        }
        images[sn] = results;
      }
      return images;
    });

    // final res =
    //     await api.get('/-/tmdbseasons/$showId?seasons=${seasons.join(',')}');
    // Map<int, Map<int, String>> images = {};
    // try {
    //   List<dynamic> list = res;
    //
    //   for (var s in List.from(list)) {
    //     int sn = s['season_number'];
    //     images[sn] = {};
    //     Map<int, String> results = {};
    //     for (var e in s['episodes']) {
    //       if (e['episode_number'] != null && e['still_path'] != null) {
    //         int en = e['episode_number'];
    //         results[en] = e['still_path'];
    //       }
    //     }
    //     images[sn] = results;
    //   }
    //   return images;
    // } catch (e) {
    //   return {};
    // }
  }

  Future<Tmdb> getDetail(String type, int id) async {
    final t = type == "" ? "show" : type;
    return (await api.get("/-/tmdbdetail/$t/$id"))
        .match((l) => Tmdb(), (r) => Tmdb.fromJson(r));
  }
}

class TmdbDetailData {
  final String type;
  final int id;

  TmdbDetailData(this.type, this.id);
}

final tmdbProvider =
    Provider((ref) => TmdbService(ref, ref.watch(apiProvider)));

final tmdbDetailProvider =
    AutoDisposeFutureProviderFamily<Tmdb, Trakt>((ref, item) async {
  print("ITEM");
  print(item);
  return await ref.watch(tmdbProvider).getDetail(item.type, item.ids.tmdb);
});
