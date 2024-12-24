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
  DB db;
  final Ref ref;
  String code = "...";
  AuthModel(this.ref, this.db) : super(false);

  Future<bool> check() async {
    var creds = await getCredentials();
    var apiUrl = creds["url"];
    var device = creds["device"];
    return apiUrl != null && device != null;
  }

  Future<dynamic> getCredentials() async {
    if (kDebugMode) {
      return {
        "url": "http://adonis-PC.dnmc.lan:8090",
        "device": "ucof4e5affm2jq0"
      };
    }

    return {
      "url": await db.hive?.get("apiUrl"),
      "device": await db.hive?.get("apiDevice")
    };
  }

  Future<void> login() async {
    final code = ref.watch(codeProvider);
    logInfo(code);
    bool result = false;

    final wsUrl = Uri.parse('wss://ntfy.sh/odinmovieshow-$code/ws');
    final channel = WebSocketChannel.connect(wsUrl);

    await channel.ready;
    var url = "";
    var id = "";
    final listen = channel.stream.listen((event) {
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

    logInfo(url);
    logInfo(id);

    listen.cancel();

    ref.read(urlProvider.notifier).state = url;
    await Future.delayed(const Duration(seconds: 5));

    try {
      final res = await Dio().get('$url/device/verify/$id');
      logInfo(res.statusCode);
      if ((res.statusCode ?? 400) >= 300) {
        ref.read(errorProvider.notifier).state = "Connection error.";
        return await login();
      } else {
        await db.hive?.put("apiUrl", url);
        await db.hive?.put("apiDevice", id);
        state = !state;
      }
    } catch (e) {
      ref.read(errorProvider.notifier).state = "Connection error.";
      logError(e, null);
      return await login();
    }
  }
}

final urlProvider = StateProvider<String>((ref) {
  return "";
});

final errorProvider = StateProvider<String>((ref) {
  return "";
});

final authProvider =
    StateNotifierProvider((ref) => AuthModel(ref, ref.watch(dbProvider)));

final codeProvider = StateProvider<String>((ref) {
  String c = const UuidV4().generate().split("-").first.toString();
  print(c);
  return c;
});
