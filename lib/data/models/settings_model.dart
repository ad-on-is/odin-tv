import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:odin/data/entities/config.dart';
import 'package:odin/data/models/auth_model.dart';
import 'package:odin/helpers.dart';

import '../services/db.dart';

List<Map<String, String>> players = [
  {'title': 'Just', 'id': 'com.brouken.player'},
  {'title': 'MX Player', 'id': 'com.mxtech.videoplayer.pro'},
  {'title': 'Nova', 'id': 'org.courville.nova'},
  {'title': 'Kodi', 'id': 'org.xbmc.kodi'},
  {'title': 'VLC', 'id': 'org.videolan.vlc'},
];

class SettingsModel with BaseHelper {
  final Ref ref;
  final DB db;
  final AuthModel auth;

  SettingsModel(this.ref, this.db, this.auth) {
    init();
  }

  Config config = Config();

  Map<String, String> get player =>
      players.firstWhere((element) => element['title'] == config.player);

  void init() async {
    logInfo("SETTING HERE");
    final dynamic mydb = await db.users?.get(auth.me!.device);
    final saved = mydb["settings"];
    config = Config(
        player: saved?['player'] ?? "Just",
        scrobble: saved?['scrobble'] ?? true);
  }

  void save() async {
    final dynamic mydb = await db.users?.get(auth.me!.device);
    mydb["settings"] = {'player': config.player, 'scrobble': config.scrobble};
  }
}

final settingsProvider = Provider((ref) => SettingsModel(
    ref, ref.watch(dbProvider.notifier), ref.watch(authProvider.notifier)));
