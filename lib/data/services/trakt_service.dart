import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odin/data/entities/tmdb.dart';
import 'package:odin/data/entities/trakt.dart';
import 'package:odin/data/entities/user.dart';
import 'package:odin/data/models/settings_model.dart';
import 'package:odin/data/services/api.dart';
import 'package:odin/data/services/tmdb_service.dart';
import 'package:odin/helpers.dart';

Map<String, dynamic> _parseAndDecodeList(String response) {
  return jsonDecode(response) as Map<String, dynamic>;
}

Future<Map<String, dynamic>> parseJsonList(String text) {
  return compute(_parseAndDecodeList, text);
}

class TraktService with BaseHelper {
  final Ref ref;
  SettingsModel settings;
  final ApiService api;

  WatchedItems watchedItems;

  TraktService(this.ref, this.watchedItems, this.api, this.settings);

  Future<void> setWatched(
      {required Trakt item, Trakt? show, Trakt? season}) async {
    String key = '';
    if (item.type == 'movie') {
      key = BaseHelper.hiveKey('movie', item.ids.trakt);
    } else {
      key = BaseHelper.hiveKey(
          'show', show!.ids.trakt, season!.number, item.number);
    }
    watchedItems.add(key);
  }

  Future<void> addToCollection(dynamic data) async {
    await api.post("/-/trakt/sync/collection", data);
  }

  Future<void> addToWatchlist(dynamic data) async {
    // final res = await dio.post('/sync/watchlist', data: data);
    return (await api.post("/-/trakt/sync/watchlist", data))
        .match((l) => null, (r) => r);
  }

  Future<dynamic> _scrobble(String endpoint, dynamic data) async {
    if (!settings.config.scrobble) return;
    return (await api.post("/-/trakt/scrobble/$endpoint", data))
        .match((l) => null, (r) => r);
  }

  void watching(Trakt item, int progress, String action) {
    final data = {
      item.type == 'movie' ? 'movie' : 'episode': _traktObject(item),
      'progress': progress
    };
    _scrobble(action, data);
  }

  Future<User> getUser() async {
    return (await api.get("/-/trakt/users/settings"))
        .match((l) => User(), (r) => User.fromTrakt(r));
  }

  Map<String, dynamic> _traktObject(Trakt m) {
    return {
      'title': m.title,
      'year': m.year,
      'ids': {
        'imdb': m.ids.imdb,
        'trakt': m.ids.trakt,
        'tmdb': m.ids.tmdb,
        'slug': m.ids.slug
      }
    };
  }

  Future<List<Trakt>> getSeasons(int showId) async {
    return (await api.get("/-/traktseasons/$showId"))
        .match((l) => [], (r) => _getItems(r));
  }

  Future<List<Trakt>> _getItems(dynamic map) async {
    List<Trakt> list = List.from(map).map((e) {
      var elem = e;
      var t = Trakt.fromJson(elem);

      if (e['episode'] != null) {
        TraktEpisode episode = TraktEpisode.fromJson(e['episode']);
        t.episode = episode;
      }
      return t;
    }).toList();

    List<Trakt> newList = await Future.wait(list.map((Trakt t) async {
      if (t.type == 'movie' && !t.watched) {
        t.setWatched(watchedItems.items
            .contains(BaseHelper.hiveKey('movie', t.ids.trakt)));
      }

      if (t.episode != null && !t.watched) {
        t.setWatched(watchedItems.items.contains(BaseHelper.hiveKey(
            'show', t.ids.trakt, t.episode!.season, t.episode!.number)));
      }
      return t;
    }));

    list.clear();

    return newList;
  }

  Future<List<Trakt>> getItems(String endpoint) async {
    return (await api.get("/-/trakt/$endpoint"))
        .match((l) => [], (r) => _getItems(r));
  }
}

final traktProvider = Provider((ref) => TraktService(
    ref,
    ref.watch(watchedProvider.notifier),
    ref.watch(apiProvider),
    ref.watch(settingsProvider)));

class WatchedItems extends StateNotifier<bool> {
  List<String> items = [];
  WatchedItems() : super(false);

  void add(String key) {
    items.add(key);
    state = !state;
  }
}

final watchedProvider = StateNotifierProvider((ref) => WatchedItems());
final seasonsProvider =
    FutureProviderFamily<List<Trakt>, TraktIds>((ref, ids) async {
  final seasons = await ref.watch(traktProvider).getSeasons(ids.trakt);
  final episodeImages = await ref
      .watch(tmdbProvider)
      .getEpisodeImages(ids.tmdb, seasons.map((s) => s.number).toList());
  for (int i = 0; i < seasons.length; i++) {
    final sn = seasons[i].number;
    for (int e = 0; e < seasons[i].episodes.length; e++) {
      final en = seasons[i].episodes[e].number;
      if (episodeImages[sn] != null && episodeImages[sn]![en] != null) {
        seasons[i].episodes[e].tmdb = Tmdb(stillPath: episodeImages[sn]![en]!);
      }
    }
  }
  return seasons;
});
