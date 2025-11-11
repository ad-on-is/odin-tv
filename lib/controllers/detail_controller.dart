import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odin/data/entities/trakt.dart';
import 'package:odin/data/models/auth_model.dart';
import 'package:odin/data/services/mqtt.dart';
import 'package:odin/data/services/trakt_service.dart';
import 'package:odin/helpers.dart';

import '../data/services/tmdb_service.dart';

class DetailController extends StateNotifier<bool> with BaseHelper {
  Trakt? item;
  final Ref ref;
  int episode = 0;
  int season = 0;
  List<Trakt> seasons = [];
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
      logInfo("Detail: ${item?.type}");
      playButtonNode.requestFocus();
    } else {
      seasonButtonNode.requestFocus();
      seasons.addAll(await traktService.getSeasons(item!.ids.trakt));
      state = !state;
      getEpisodeImages();
    }
    ref.read(mqttProvider).disConnectMQTT();
    // seasonWorker = ever(season, (_) {
    //   getEpisodeImages(season.value);
    // });

    // state = !state;
  }

  Future<void> getTraktSeasons() async {}

  void getEpisodeImages() async {
    episodeImages = await tmdbService.getEpisodeImages(
        item?.ids.tmdb ?? 0, seasons.map((s) => s.number).toList());
    state = !state;
  }

  Future<void> playTrailer() async {
    const intent = AndroidIntent(
      action: 'action_view',
      package: "com.teamsmart.videomanager.tv",
      data: "https://youtube.com/watch?v=9vN6DHB6bJc",
      arguments: {
        'force_fullscreen': 'true',
        'finish_on_end': 'true',
      },
      flags: [
        Flag.FLAG_ACTIVITY_MULTIPLE_TASK,
        Flag.FLAG_ACTIVITY_NO_HISTORY,
      ],
    );
    await intent.launch();
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

final selectedSeasonProvider = StateProvider<int>((ref) => 0);
