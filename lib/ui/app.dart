import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:helpers/helpers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:odin/controllers/app_controller.dart';
import 'package:odin/theme.dart';
import 'package:odin/ui/appbar.dart';
import 'package:odin/ui/settings.dart';
import 'package:odin/ui/widgets/widgets.dart';

import '../data/models/item_model.dart';

class App extends HookConsumerWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageState = ref.watch(appPageProvider);
    final appBusy = ref.watch(appBusyProvider);
    return DefaultTabController(
      length: pages.length,
      child: Scaffold(
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
                  const AppBackground(),
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        const OdinAppBar(),
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
                            child: pages[pageState]),
                      ],
                    ),
                  ),
                  const RefreshNotification(),
                ],
              ),
      ),
    );
  }
}

class AppBackground extends ConsumerWidget {
  const AppBackground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final background = ref.watch(pageBackgroundProvider);

    return Stack(children: <Widget>[
      background.isEmpty
          ? Container()
          : CachedNetworkImage(
              imageUrl: background,
              fit: BoxFit.fill,
              errorWidget: (_, __, ___) => Container(color: AppColors.darkGray),
              placeholder: (_, __) => Container(color: AppColors.darkGray),
            ),
      Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
              AppColors.darkGray.withAlpha(200),
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
