import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odin/data/entities/scrape.dart';
import 'package:odin/data/entities/trakt.dart';
import 'package:odin/data/services/api.dart';
import 'package:odin/data/services/db.dart';
import 'package:odin/helpers.dart';

class ScrapeService extends StateNotifier<bool> with BaseHelper {
  final DB db;
  final HiveBox hive;
  final Ref ref;
  ScrapeService(this.ref, this.db, this.hive) : super(false);

  Future<List<Scrape>> scrape(
      {required Trakt item,
      Trakt? show,
      Trakt? season,
      bool doCache = true}) async {
    Map<String, dynamic> data = {};

    if (item.type == 'movie') {
      data = {
        'type': 'movie',
        'trakt': "${item.ids.trakt}",
        'imdb': "${item.ids.imdb}",
        'title': "${item.title}",
        'year': "${item.year}",
      };
    } else {
      data = {
        'type': 'episode',
        'show_imdb': "${show?.ids.imdb}",
        'show_tvdb': "${show?.ids.tvdb}",
        'show_title': "${show?.title}",
        'show_year': "${show?.year}",
        'season_number': "${season?.number}",
        'episode_imdb': "${item.ids.imdb}",
        'episode_trakt': "${item.ids.trakt}",
        'episode_tvdb': "${item.ids.tvdb}",
        'episode_title': "${item.title}",
        'episode_number': "${item.number}",
        'episode_year': "${item.year}",
        'season_aired': "${season?.firstAired}",
        'no_seasons': "${show?.seasons.length}",
        'country': "${show?.language}",
      };
    }

    final api = ref.watch(apiProvider);

    final res = await api.post('/scrape', data);

    return res.match(
        (l) => [], (r) => List.from(r).map((e) => Scrape.fromJson(e)).toList());
  }
}

final scrapeProvider = Provider((ref) =>
    ScrapeService(ref, ref.watch(dbProvider), ref.watch(hiveProvider)));
