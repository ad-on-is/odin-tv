import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odin/data/services/api.dart';
import 'package:odin/data/services/db.dart';
import 'package:odin/helpers.dart';
import 'package:uuid/v4.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

enum AuthState { ok, login, error, multiple, add, select }

class ValidationStatus {
  final int status;
  final dynamic user;
  ValidationStatus(this.status, this.user);
}

class AuthObject {
  final String device;
  final String url;
  final dynamic user;

  AuthObject(this.device, this.url, this.user);
}

class AuthModel extends StateNotifier<AuthState> with BaseHelper {
  DB db;
  ValidationService validation;
  final Ref ref;
  String code = "...";
  AuthObject? me;
  AuthModel(this.ref, this.db, this.validation) : super(AuthState.error);

  Future<void> check({bool showSelect = false}) async {
    final allcreds = await getAllCreds();
    if (allcreds.isEmpty) {
      login();
      return;
    }
    if (allcreds.length > 1 || showSelect) {
      state = AuthState.multiple;
      return;
    }

    if (await verify(allcreds[0]) == false) {
      return;
    }
    me = allcreds[0];
    state = AuthState.ok;
  }

  Future<void> newUser() async {
    login();
  }

  switchUser() {
    state = AuthState.multiple;
  }

  Future<void> selectUser(AuthObject creds) async {
    logInfo("Selecting");
    if (!await verify(creds)) {
      return;
    }
    logInfo("Should be here");
    me = creds;
    state = AuthState.ok;
  }

  Future<bool> verify(AuthObject creds) async {
    final v = await validate(creds.url, creds.device);
    if (v.status == 0) {
      state = AuthState.error;
      return false;
    }
    if (v.status == 404) {
      await clear(creds.device);
      login();
      return false;
    }
    return true;
  }

  Future<void> delete(String id) async {
    logWarning(id);
    await db.users?.delete(id);
    check(showSelect: true);
  }

  Future<void> clear(String device) async {
    await db.users?.delete(device);
  }

  Future<ValidationStatus> validate(String url, String id) async {
    return (await validation.check(url, id)).match(
        (l) => ValidationStatus(0, null),
        (r) => ValidationStatus(r["status"], r["user"]));
  }

  Future<dynamic> getCredentials() async {
    final allcreds = await getAllCreds();
    final me = allcreds[0];

    return {"url": me.url, "device": me.device};
  }

  Future<List<AuthObject>> getAllCreds() async {
    final creds = <AuthObject>[];
    if (kDebugMode) {
      creds.add(AuthObject(
          dotenv.env["TOKEN"] ?? "", dotenv.env["APP_URL"] ?? "", "test"));
      return creds;
    }
    final List<String>? allcreds = await db.users?.getAllKeys();
    if (allcreds == null || allcreds.isEmpty) {
      return [];
    }

    await Future.forEach(allcreds, (String c) async {
      final data = await db.users?.get(c);
      creds.add(AuthObject(c, data["apiUrl"], data["user"]));
    });

    return creds;
  }

  Future<void> login() async {
    state = AuthState.login;
    ref.read(urlProvider.notifier).state = "";
    final code = ref.refresh(codeProvider);
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

    final v = await validate(url, id);

    if (v.status > 0 && v.status < 300) {
      await db.users?.put(id, {"apiUrl": url, "user": v.user});
      logOk("Auth: Successful!");
      me = AuthObject(id, url, v.user);
      state = AuthState.ok;
    } else {
      if (v.status == 0) {
        ref.read(errorProvider.notifier).state =
            "Network error: Cannot reach URL";
      }
      if (v.status > 399) {
        ref.read(errorProvider.notifier).state =
            "Authorization error: Something is wrong";
      }
      state = AuthState.login;
      return await login();
    }
  }
}

final urlProvider = StateProvider<String>((ref) {
  return "";
});

final usersProvider = FutureProvider<List<AuthObject>>((ref) {
  return ref.watch(authProvider.notifier).getAllCreds();
});

final errorProvider = StateProvider<String>((ref) {
  return "";
});

final authProvider = StateNotifierProvider((ref) => AuthModel(
    ref, ref.watch(dbProvider.notifier), ref.watch(validationProvider)));

final codeProvider = StateProvider<String>((ref) {
  String c = const UuidV4().generate().split("-").first.toString();
  return c;
});
