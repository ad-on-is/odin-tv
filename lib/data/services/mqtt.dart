import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:odin/data/services/api.dart';
import 'package:odin/helpers.dart';

class MQTTService with BaseHelper {
  ApiService api;
  MQTTService(this.api);

  // final String? host;
  // final String? topic;
  // final int? port;

  String? topic;

  late MqttServerClient client;

  Future initializeMQTTClient(String host, int port, String topic) async {
    this.topic = topic;

    final res = await api.get('/mqttconfig');
    final conf = res.match((l) => {}, (r) => r);

    client = MqttServerClient(conf["url"], 'odin-movieshows-app')
      ..port = port
      ..logging(on: false)
      ..onDisconnected = onDisConnected
      ..setProtocolV311()
      ..onSubscribed = onSubscribed
      ..keepAlivePeriod = 20
      ..useWebSocket = true
      // ..secure = true
      ..onConnected = onConnected;

    final connMess = MqttConnectMessage()
        .withClientIdentifier('taylanyildz')
        .withWillTopic('willTopic')
        .withWillMessage('willMessage')
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);
    log('Connecting....');
    client.connectionMessage = connMess;
    await connectMQTT(conf["user"], conf["password"]);
  }

  Future connectMQTT(String user, String password) async {
    try {
      await client.connect(user, password);
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

final mqttProvider = Provider((ref) => MQTTService(ref.watch(apiProvider)));
