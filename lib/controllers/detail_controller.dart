import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odin/data/entities/trakt.dart';
import 'package:odin/data/models/auth_model.dart';
import 'package:odin/data/services/trakt_service.dart';
import 'package:odin/helpers.dart';

import '../data/services/tmdb_service.dart';

class DetailController extends StateNotifier<bool> with BaseHelper {
  Trakt? item;
  final Ref ref;
  int episode = 0;
  int season = 0;
  final TraktService traktService;
  final TmdbService tmdbService;
  final AuthModel auth;
  Map<int, Map<int, String>> episodeImages = {};
  DetailController(this.ref, this.traktService, this.tmdbService, this.auth)
      : super(false);
  final FocusNode playButtonNode = FocusNode();
  final seasonButtonNode = FocusNode();
  // Worker? seasonWorker;
  void onInit(Trakt i) async {
    item = i;
    if (item?.type == 'movie') {
      playButtonNode.requestFocus();
    } else {
      seasonButtonNode.requestFocus();
      getEpisodeImages();
    }
    // seasonWorker = ever(season, (_) {
    //   getEpisodeImages(season.value);
    // });

    // state = !state;
  }

  void getEpisodeImages() async {
    episodeImages = await tmdbService.getEpisodeImages(
        item?.ids.tmdb ?? 0, item?.seasons.map((s) => s.number).toList() ?? []);
    state = !state;
  }

  void playTrailer() {
    // mediaItemModel.playTrailer(mediaItem);
  }

  String getEpisodeImage(int season, int episode) {
    const String url = 'https://image.tmdb.org/t/p/w185';
    if (episodeImages[season] != null &&
        episodeImages[season]![episode] != null) {
      return url + episodeImages[season]![episode]!;
    }
    return url;
  }

  void onClose() {
    // seasonWorker?.dispose();
    // super.onClose();
  }

  void setSeason(int s) {
    season = s;
    episode = 0;
    state = !state;
  }

  void setEpisode(int e) async {
    episode = e;
    state = !state;
  }
}

final detailController = StateNotifierProvider.autoDispose((ref) =>
    DetailController(ref, ref.watch(traktProvider), ref.watch(tmdbProvider),
        ref.watch(authProvider.notifier)));
