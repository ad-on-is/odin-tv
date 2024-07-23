import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odin/data/services/db.dart';
import 'package:odin/helpers.dart';
import 'package:uuid/v4.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class AuthModel extends StateNotifier<bool> with BaseHelper {
  HiveBox hive;
  final Ref ref;
  String code = "...";
  AuthModel(this.ref, this.hive) : super(false);

  Future<bool> check() async {
    var creds = await getCredentials();
    var apiUrl = creds["url"];
    var device = creds["device"];

    return apiUrl != null && device != null;
  }

  Future<dynamic> getCredentials() async {
    if (kDebugMode) {
      return {
        "url": "https://local-8090.add.dnmc.in",
        "device": "ucof4e5affm2jq0"
      };
    }

    return {
      "url": await hive.hive?.get("apiUrl"),
      "device": await hive.hive?.get("apiDevice")
    };
  }

  Future<void> login() async {
    final code = ref.watch(codeProvider);
    logInfo(code);
    bool result = false;

    final wsUrl = Uri.parse('wss://ntfy.sh/odinmovieshows-$code/ws');
    final channel = WebSocketChannel.connect(wsUrl);

    await channel.ready;
    var url = "";
    var id = "";
    channel.stream.listen((event) {
      try {
        var data = json.decode(event as String);
        if (data["message"] != null) {
          var m = json.decode(data["message"]);
          url = m["url"].replaceAll('"', "");
          id = m["deviceId"].replaceAll('"', "");
          result = true;
        }
      } catch (_) {
        // print(e);
      }
    });

    while (!result) {
      await Future.delayed(const Duration(seconds: 1));
    }

    ref.read(urlProvider.notifier).state = url;
    logInfo(url);
    logInfo(id);

    try {
      await Dio().get('$url/device/verify/$id');
      await hive.hive?.put("apiUrl", url);
      await hive.hive?.put("apiDevice", id);
    } catch (e) {
      logError(e, null);
    }

    state = !state;
  }
}

final urlProvider = StateProvider<String>((ref) {
  return "";
});

final authProvider =
    StateNotifierProvider((ref) => AuthModel(ref, ref.watch(hiveProvider)));

final codeProvider = StateProvider<String>((ref) {
  String c = const UuidV4().generate().split("-").first.toString();
  return c;
});
