import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:helpers/helpers.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:odin/data/models/auth_model.dart';
import 'package:odin/data/models/settings_model.dart';
import 'package:odin/data/services/db.dart';
import 'package:odin/helpers.dart';
import 'package:odin/theme.dart';
import 'package:odin/ui/app.dart';
import 'package:odin/ui/login.dart';
import 'package:odin/ui/widgets/widgets.dart';

class PVLogger extends ProviderObserver with BaseHelper {
  @override
  void didUpdateProvider(
    ProviderBase<Object?> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    // logWarning(provider.argument ?? provider.name ?? provider.runtimeType);
  }

  @override
  void didAddProvider(ProviderBase<Object?> provider, Object? value,
      ProviderContainer container) {
    // log(provider.argument ?? provider.name ?? provider.runtimeType);
  }

  @override
  void didDisposeProvider(
      ProviderBase<Object?> provider, ProviderContainer container) {
    // logOk(provider.argument ?? provider.name ?? provider.runtimeType);
  }
}

final initProvider = StreamProvider<bool>((ref) async* {
  await Hive.initFlutter();
  final db = ref.read(dbProvider);
  db.hive = await Hive.openLazyBox('odin');
  final auth = ref.read(authProvider.notifier);

  ref.read(settingsProvider).init();
  await auth.check();
  yield true;
});

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ProviderScope(observers: [PVLogger()], child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, ref) {
    final init = ref.watch(initProvider);
    final auth = ref.watch(authProvider);

    return Shortcuts(
      shortcuts: <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.select): const ActivateIntent(),
      },
      child: MaterialApp(
        // initialBinding: AppBinding(),
        debugShowCheckedModeBanner: false,
        title: 'Odin',
        theme: AppThemes.defaultTheme,
        themeMode: ThemeMode.dark,
        home: init.when(
            data: (value) => auth == AuthState.ok ? const App() : const Login(),
            error: (_, __) => Container(),
            loading: () => Container(
                  color: AppColors.darkGray,
                  child: Center(
                      child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const OdinLogo(height: 50),
                      const SizedBox(height: 15),
                      const BodyText1(
                          'Enjoy your favorite movies and tv shows'),
                      const SizedBox(height: 50),
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: AppColors.red,
                        ),
                      ),
                    ],
                  )),
                )),
        // locale: Locale('en', 'US'),
      ),
    );
  }
}
