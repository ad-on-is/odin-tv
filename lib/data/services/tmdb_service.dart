import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odin/data/models/auth_model.dart';
import 'package:odin/data/services/db.dart';
import 'package:odin/helpers.dart';

class TmdbService with BaseHelper {
  String url = 'https://api.themoviedb.org/3';
  String imageURL = 'https://image.tmdb.org/t/p/w500';
  final DB db;
  final AuthModel auth;
  final Ref ref;
  Dio dio = Dio();

  TmdbService(this.ref, this.db, this.auth) {
    dio.options.baseUrl = url;
    dio.interceptors.add(InterceptorsWrapper(onError: (e, handler) {
      logWarning(e.requestOptions.uri);
      logError(e, e.stackTrace);
      return handler.next(e);
    }, onRequest: (options, handler) async {
      var creds = await auth.getCredentials();
      var apiUrl = creds["url"];
      var device = creds["device"];
      options.baseUrl = '$apiUrl';
      options.headers.addAll({'Device': device});
      return handler.next(options);
    }));
  }

  Future<Map<int, Map<int, String>>> getEpisodeImages(
      int showId, List<int> seasons) async {
    final res =
        await dio.get('/tmdbseasons/$showId?seasons=${seasons.join(',')}');
    Map<int, Map<int, String>> images = {};
    try {
      List<dynamic> list = res.data;

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
    } catch (e) {
      return {};
    }
  }
}

final tmdbProvider = Provider((ref) =>
    TmdbService(ref, ref.watch(dbProvider), ref.watch(authProvider.notifier)));
