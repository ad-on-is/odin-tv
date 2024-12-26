import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odin/data/entities/config.dart';
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
  DB db;

  SettingsModel(this.ref, this.db) {
    init();
  }

  Config config = Config();

  Map<String, String> get player =>
      players.firstWhere((element) => element['title'] == config.player);

  void init() async {
    var saved = await db.hive?.get('config');
    if (saved != null) {
      config = Config(player: saved['player']);
    }
  }

  void save() {
    db.hive?.put('config', {'player': config.player});
  }
}

final settingsProvider =
    Provider((ref) => SettingsModel(ref, ref.watch(dbProvider)));
