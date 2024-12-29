import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:odin/data/models/auth_model.dart';
import 'package:odin/helpers.dart';

class MQTTService with BaseHelper {
  MQTTService(this.auth);
  AuthModel auth;

  String? topic;

  late MqttServerClient client;

  Future initializeMQTTClient(String topic) async {
    this.topic = topic;
    final creds = await auth.getCredentials();
    final uri = Uri.parse(creds["url"]);
    final host = uri.host;
    final proto = uri.scheme == "https" ? "wss://" : "ws://";

    client = MqttServerClient("$proto$host/ws/mqtt", 'odin-movieshows-app')
      ..port = uri.port
      ..logging(on: false)
      ..onDisconnected = onDisConnected
      ..setProtocolV311()
      ..onSubscribed = onSubscribed
      ..keepAlivePeriod = 60 * 15
      ..useWebSocket = true
      ..autoReconnect = true
      ..resubscribeOnAutoReconnect = true
      ..onConnected = onConnected;

    final connMess = MqttConnectMessage()
        .withClientIdentifier('odin-movieshows-app')
        .withWillTopic('willTopic')
        .withWillMessage('willMessage')
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);
    log('Connecting....');
    client.connectionMessage = connMess;
    await connectMQTT();
  }

  Future connectMQTT() async {
    try {
      await client.connect();
    } on NoConnectionException catch (e) {
      logWarning(e.toString());
      client.disconnect();
    }
  }

  void disConnectMQTT() {
    try {
      client.disconnect();
    } catch (e) {
      logWarning(e.toString());
    }
  }

  void subscirbe(String topic) {
    try {
      client.subscribe(topic, MqttQos.atLeastOnce);
    } catch (e) {
      logWarning(e.toString());
    }
  }

  void unsubscribe(String topic) {
    try {
      client.unsubscribe(topic);
    } catch (e) {
      logWarning(e.toString());
    }
  }

  void onConnected() {
    logOk('Connected');

    try {
      client.subscribe(topic!, MqttQos.atLeastOnce);
    } catch (e) {
      logWarning(e.toString());
    }
  }

  void onDisConnected() {
    logOk('Disconnected');
  }

  void puslish(String message) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);

    client.publishMessage('sensor/home', MqttQos.atLeastOnce, builder.payload!);
    builder.clear();
  }

  void onSubscribed(String topic) {
    logInfo(topic);
  }
}

final mqttProvider =
    Provider((ref) => MQTTService(ref.watch(authProvider.notifier)));
