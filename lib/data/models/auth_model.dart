import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odin/data/services/api.dart';
import 'package:odin/data/services/db.dart';
import 'package:odin/helpers.dart';
import 'package:uuid/v4.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class AuthModel extends StateNotifier<bool> with BaseHelper {
  DB db;
  ValidationService validation;
  final Ref ref;
  String code = "...";
  AuthModel(this.ref, this.db, this.validation) : super(false);

  Future<bool> check() async {
    var creds = await getCredentials();
    var apiUrl = creds["url"];
    var device = creds["device"];
    logInfo(apiUrl);
    logInfo(device);
    return apiUrl != null && device != null;
  }

  Future<bool> credsValid() async {
    var creds = await getCredentials();
    var status = await validate(creds['url'], creds['device']);
    return status > 0 && status < 300;
  }

  Future<bool> healthy() async {
    var creds = await getCredentials();
    var status = await validate(creds['url'], creds['device']);
    return status != 0;
  }

  Future<void> clear() async {
    await db.hive?.put("apiUrl", null);
    await db.hive?.put("apiDevice", null);
  }

  Future<int> validate(String url, String id) async {
    return (await validation.check(url, id)).match((l) => 0, (r) => r);
  }

  Future<dynamic> getCredentials() async {
    if (kDebugMode) {
      return {
        "url": "http://adonis-PC.dnmc.lan:6060",
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

    final status = await validate(url, id);

    if (status > 0 && status < 300) {
      await db.hive?.put("apiUrl", url);
      await db.hive?.put("apiDevice", id);
      state = !state;
    } else {
      if (status == 0) {
        ref.read(errorProvider.notifier).state =
            "Network error: Cannot reach URL";
      }
      if (status > 399) {
        ref.read(errorProvider.notifier).state =
            "Authorization error: Something is wrong";
      }
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

final authProvider = StateNotifierProvider((ref) =>
    AuthModel(ref, ref.watch(dbProvider), ref.watch(validationProvider)));

final codeProvider = StateProvider<String>((ref) {
  String c = const UuidV4().generate().split("-").first.toString();
  return c;
});
