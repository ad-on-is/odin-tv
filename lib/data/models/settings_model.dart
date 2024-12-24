import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odin/data/entities/config.dart';
import 'package:odin/helpers.dart';

import '../services/db.dart';

List<Map<String, String>> players = [
  {'title': 'MX Player', 'id': 'com.mxtech.videoplayer.pro'},
  {'title': 'Kodi', 'id': 'org.xbmc.kodi'},
  {'title': 'VLC', 'id': 'org.videolan.vlc'},
  {'title': 'Nova', 'id': 'org.courville.nova'},
  {'title': 'Just', 'id': 'com.brouken.player'},
];

class SettingsModel with BaseHelper {
  final Ref ref;
  DB hive;

  SettingsModel(this.ref, this.hive) {
    init();
  }

  Config config = Config();

  Map<String, String> get player =>
      players.firstWhere((element) => element['title'] == config.player);

  void init() async {
    var saved = await hive.hive?.get('config');
    if (saved != null) {
      config = Config(player: saved['player']);
    }

    // Random r = new Random();
    // String key = base64.encode(List<int>.generate(8, (_) => r.nextInt(255)));

    // HttpClient client = HttpClient();
    // HttpClientRequest request =
    //     await client.getUrl(Uri.parse('https://ntfy.sh/odinmovieshows-2222'));
    // request.headers.add('connection', 'Upgrade');
    // request.headers.add('upgrade', 'websocket');
    // request.headers.add('Sec-WebSocket-Version', '13');
    // request.headers.add('Sec-WebSocket-Key', key);
    // HttpClientResponse response = await request.close();

    // Socket socket = await response.detachSocket();

    // WebSocket ws = WebSocket.fromUpgradedSocket(socket, serverSide: false);
    // logInfo("Listening");
    // ws.listen((event) {
    //   print(event);
    // });
  }

  void save() {
    hive.hive?.put('config', {'player': config.player});
  }
}

final settingsProvider =
    Provider((ref) => SettingsModel(ref, ref.watch(dbProvider)));
