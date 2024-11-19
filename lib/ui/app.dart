import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:helpers/helpers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:odin/controllers/app_controller.dart';
import 'package:odin/theme.dart';
import 'package:odin/ui/appbar.dart';
import 'package:odin/ui/focusnodes.dart';
import 'package:odin/ui/settings.dart';
import 'package:odin/ui/widgets/widgets.dart';

import '../data/models/item_model.dart';

class App extends HookConsumerWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageState = ref.watch(appPageProvider);
    final appBusy = ref.watch(appBusyProvider);
    return Stack(
      children: [
        const AppBackground(),
        DefaultTabController(
          length: pages.length,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              toolbarHeight: 35,
              leading: const Padding(
                padding: EdgeInsets.only(left: 20),
                child: OdinLogo(),
              ),
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              actions: [
                SizedBox(
                  height: 20,
                  child: Row(
                    children: [
                      TextButton(
                        focusNode: menufocus[1],
                        child: BodyText1(
                          'Home',
                          style:
                              TextStyle(fontSize: 10, color: AppColors.purple),
                        ),
                        onPressed: () {
                          ref.read(appPageProvider.notifier).state = 0;
                        },
                      ),
                      const SizedBox(width: 5),
                      TextButton(
                        focusNode: menufocus[2],
                        child: BodyText1(
                          'Movies',
                          style:
                              TextStyle(fontSize: 10, color: AppColors.purple),
                        ),
                        onPressed: () {
                          ref.read(appPageProvider.notifier).state = 1;
                        },
                      ),
                      const SizedBox(width: 5),
                      TextButton(
                        focusNode: menufocus[3],
                        child: BodyText1(
                          'TV Shows',
                          style:
                              TextStyle(fontSize: 10, color: AppColors.purple),
                        ),
                        onPressed: () {
                          ref.read(appPageProvider.notifier).state = 2;
                        },
                      ),
                      IconButton(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 5),
                        focusColor: Colors.white.withAlpha(40),
                        focusNode: menufocus[0],
                        icon: Icon(FontAwesomeIcons.gear,
                            size: 10, color: AppColors.purple),
                        onPressed: () => Scaffold.of(context).openEndDrawer(),
                      ),
                    ],
                  ),
                )
              ],
            ),
            endDrawer: Drawer(
                backgroundColor: AppColors.darkGray.withAlpha(240),
                child: const Settings()),
            body: appBusy
                ? const Center(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          OdinLogo(),
                          Headline4('Enjoy movies and shows.')
                        ]),
                  )
                : Stack(
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            PageTransitionSwitcher(
                                transitionBuilder: (
                                  Widget child,
                                  Animation<double> animation,
                                  Animation<double> secondaryAnimation,
                                ) {
                                  return SharedAxisTransition(
                                    transitionType:
                                        SharedAxisTransitionType.horizontal,
                                    animation: animation,
                                    fillColor: Colors.transparent,
                                    secondaryAnimation: secondaryAnimation,
                                    child: child,
                                  );
                                },
                                child: pages[pageState])
                          ],
                        ),
                      ),
                      const RefreshNotification(),
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}

class AppBackground extends ConsumerWidget {
  const AppBackground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final background = ref.watch(selectedItemProvider).tmdb?.backdropBig ?? "";

    return Stack(children: <Widget>[
      background.isEmpty
          ? Container()
          : SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: CachedNetworkImage(
                imageUrl: background,
                fit: BoxFit.fill,
                errorWidget: (_, __, ___) =>
                    Container(color: AppColors.darkGray),
                placeholder: (_, __) => Container(color: AppColors.darkGray),
              ),
            ),
      Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
              AppColors.darkGray.withAlpha(230),
              AppColors.darkGray,
              // AppColors.darkGray.withAlpha(250),
            ])),
      ),
    ]);
  }
}

class RefreshNotification extends ConsumerWidget {
  const RefreshNotification({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final refresh = ref.watch(appRefreshProvider);

    return refresh == false
        ? const SizedBox()
        : Container(
            alignment: Alignment.bottomRight,
            child: Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppColors.green),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                      height: 10,
                      width: 10,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.black,
                      )),
                  SizedBox(width: 10),
                  CaptionText(
                    'Refreshing',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
          );
  }
}
