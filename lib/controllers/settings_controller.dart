import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odin/data/entities/config.dart';
import 'package:odin/data/models/settings_model.dart';

class SettingsController extends StateNotifier<bool> {
  final Ref ref;

  SettingsModel settings;
  Config get config => settings.config;

  SettingsController(this.ref, this.settings) : super(false) {
    // auth = ref!.watch(authProvider);
  }

  void save() {
    settings.save();
    // state = !state;
  }
}

final settingsController = StateNotifierProvider(
    (ref) => SettingsController(ref, ref.watch(settingsProvider)));
