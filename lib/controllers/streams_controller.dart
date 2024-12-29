import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:helpers/helpers.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:odin/controllers/detail_controller.dart';
import 'package:odin/data/entities/scrape.dart';
import 'package:odin/data/entities/trakt.dart';
import 'package:odin/data/models/settings_model.dart';
import 'package:odin/data/services/api.dart';
import 'package:odin/data/services/mqtt.dart';
import 'package:odin/data/services/scrape_service.dart';
import 'package:odin/data/services/trakt_service.dart';
import 'package:odin/helpers.dart';
import 'package:odin/ui/dialogs/default.dart';

import '../theme.dart';

class StreamUrl {
  String filename;
  int filesize;
  String download;
  List<String> info;
  String quality;

  StreamUrl(
      this.filename, this.filesize, this.download, this.info, this.quality);
}

class StreamsController extends StateNotifier<bool> with BaseHelper {
  ScrapeService scrapeService;
  ApiService api;
  MQTTService mqtt;
  TraktService traktService;
  DetailController detail;
  SettingsModel settings;
  Map<String, String> get player => settings.player;
  final Ref ref;
  bool inited = false;

  Trakt? item;
  Trakt? show;
  Trakt? season;
  bool confirmed = false;
  String status = "Scraping";

  String playerTitle = '';

  Map<String, List<Scrape>> scrapes = {
    'HDR': [],
    '4K': [],
    '1080p': [],
    '720p': [],
    'SD': [],
    'CAM': []
  };

  StreamsController(this.ref, this.api, this.mqtt, this.scrapeService,
      this.traktService, this.settings, this.detail)
      : super(false);

  void init(Trakt item, Trakt? show, Trakt? season) async {
    inited = true;
    this.item = item;
    this.show = show;
    this.season = season;
    if (item.type == 'movie') {
      playerTitle = '${item.title} (${item.year})';
    } else {
      playerTitle =
          '${show?.title} (${show?.year}) - S${season?.number}E${item.number} - ${item.title}';
    }

    getUrls();
  }

  // test

  DateTime? startPlay;
  DateTime? endPlay;

  Future<void> confirmProbablyWatched(int percent, BuildContext ctx) async {
    return await showDialog(
        context: ctx,
        builder: (dctx) => DefaultDialog(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Headline3('You only watched $percent%'),
                    const BodyText1('Do you want to mark it as watched?'),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextButton(
                          child: const BodyText1('Yes, mark as watched'),
                          onPressed: () {
                            confirmed = true;
                            Navigator.of(dctx).pop();
                          },
                        ),
                        const SizedBox(width: 20),
                        TextButton(
                          child: const BodyText1('No, I will watch later'),
                          onPressed: () {
                            confirmed = false;
                            Navigator.of(dctx).pop();
                          },
                        )
                      ],
                    )
                  ],
                ),
              ),
            ));
  }

  // // invoked when coming back from player
  void checkInTrakt(BuildContext ctx) async {
    if (startPlay == null) return;

    endPlay = DateTime.now();
    final duration = endPlay!.difference(startPlay!);
    double p = 100 / item!.runtime * duration.inMinutes;
    int progress = p.round();
    startPlay = null;
    if (progress < 0) progress = 0;
    if (progress >= 75) {
      progress = 100;
      traktService.setWatched(item: item!, show: show, season: season);
    } else {
      await confirmProbablyWatched(progress, ctx);
      if (confirmed) {
        progress = 100;
        traktService.setWatched(item: item!, show: show, season: season);
      }
    }
    traktService.watching(item!, progress, 'stop');
    detail.state = !detail.state;
  }

  void getUrls({bool cache = true}) async {
    logWarning("getting Urls");
    String topic = 'odin-movieshow/movie/${item!.ids.trakt}';
    if (show != null) {
      topic = 'odin-movieshow/episode/${item!.ids.trakt}';
    }
    await mqtt.initializeMQTTClient(topic);
    mqtt.client.updates!.listen((dynamic t) {
      final MqttPublishMessage recMess = t[0].payload;
      final message =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      if (message == "SCRAPING_DONE") {
        status = "Done";
        state = !state;
        return;
      }
      final s = Scrape.fromJson(json.decode(message));
      String q = s.quality;
      if (q == '4K' && (s.info.contains('HDR') || s.info.contains('DV'))) {
        q = 'HDR';
      }
      // logInfo(s.title);
      scrapes[q]!.add(s);
      state = !state;
    });

    await scrapeService.scrape(
        item: item!, show: show, season: season, doCache: cache);

    await Future.delayed(const Duration(seconds: 1));
    state = !state;
  }

  List<StreamUrl> allUrls() {
    List<StreamUrl> all = [];

    scrapes.forEach((q, values) {
      for (var s in values) {
        for (var link in s.links) {
          var su = StreamUrl(
              link["filename"], link["filesize"], link["download"], s.info, q);
          all.add(su);
        }
      }
    });

    return all;
  }

  void openPlayer(String url) async {
    _launchPlayer(url);
  }

  void _startWatching() {
    startPlay = DateTime.now();
    traktService.watching(item!, 0, 'start');
  }

  void _launchPlayer(String url) async {
    final intent = AndroidIntent(
      action: 'action_view',
      package: player['id'], // com.mxtech.videoplayer.pro
      type: 'video/*',
      data: url,
      arguments: {'title': playerTitle},
    );
    _startWatching();
    await intent.launch();
  }
}

final streamsController = StateNotifierProvider.autoDispose((ref) {
  final mqtt = ref.watch(mqttProvider);
  ref.onDispose(() {
    mqtt.client.disconnect();
  });
  return StreamsController(
      ref,
      ref.watch(apiProvider),
      mqtt,
      ref.watch(scrapeProvider),
      ref.watch(traktProvider),
      ref.watch(settingsProvider),
      ref.watch(detailController.notifier));
});
