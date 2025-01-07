import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:helpers/helpers.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:odin/data/models/auth_model.dart';
import 'package:odin/data/services/db.dart';
import 'package:odin/helpers.dart';
import 'package:odin/theme.dart';
import 'package:odin/ui/app.dart';
import 'package:odin/ui/login.dart';
import 'package:odin/ui/selectbuttonfixer.dart';
import 'package:odin/ui/userselect.dart';
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

final selectButtonProvider = StateProvider<int>((ref) {
  return 0;
});

final initProvider = StreamProvider<bool>((ref) async* {
  final sb = ref.watch(selectButtonProvider);
  await Hive.initFlutter();
  final db = ref.read(dbProvider.notifier);
  final collection = await BoxCollection.open(
    'OdinBox',
    {'users'},
    path: './',
  );
  db.users = await collection.openBox("users");
  db.hive = await Hive.openLazyBox("odin");
  int select = (await db.hive?.get("selectKey")) ?? 0;
  if (sb > 0) {
    await db.hive?.put("selectKey", sb);
    select = sb;
  }
  final auth = ref.read(authProvider.notifier);
  await auth.check();
  yield select != 0;
});

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ProviderScope(observers: [PVLogger()], child: const MyApp()));
}

class LoadingScreen extends StatelessWidget {
  final String title;
  const LoadingScreen(
      {Key? key, this.title = "Enjoy your favorite movies and tv shows"})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.darkGray,
      child: Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const OdinLogo(height: 50),
          const SizedBox(height: 15),
          BodyText1(title),
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
    );
  }
}

class AppBasedOnAuth extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ref) {
    final auth = ref.watch(authProvider);
    switch (auth) {
      case AuthState.login:
        return const Login();
      case AuthState.multiple:
        return const UserSelect();
      case AuthState.error:
        return const LoadingScreen(
          title: "Error: Cannot connect to the API.",
        );
    }
    return const App();
  }
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, ref) {
    final init = ref.watch(initProvider);

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
            data: (value) =>
                !value ? const SelectButtonFixer() : AppBasedOnAuth(),
            error: (_, __) => Container(),
            loading: () => Container(
                  color: AppColors.darkGray,
                  child: const LoadingScreen(),
                )),
        // locale: Locale('en', 'US'),
      ),
    );
  }
}
