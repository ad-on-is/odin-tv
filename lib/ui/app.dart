import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:helpers/helpers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:odin/controllers/app_controller.dart';
import 'package:odin/theme.dart';
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
                Consumer(
                  builder: (context, ref, child) {
                    final page = ref.watch(appPageProvider);
                    return SizedBox(
                      height: 20,
                      child: Row(
                        children: [
                          TextButton(
                            focusNode: menufocus[1],
                            // style: ButtonStyle(
                            //     backgroundColor: WidgetStatePropertyAll(
                            //         AppColors.purple
                            //             .withAlpha(page == 0 ? 80 : 0))),
                            child: const BodyText1(
                              'Home',
                              style: TextStyle(fontSize: 10),
                            ),
                            onPressed: () {
                              ref.read(appPageProvider.notifier).state = 0;
                            },
                          ),
                          const SizedBox(width: 5),
                          TextButton(
                            focusNode: menufocus[2],
                            style: ButtonStyle(
                                backgroundColor: WidgetStatePropertyAll(
                                    AppColors.purple
                                        .withAlpha(page == 1 ? 80 : 0))),
                            child: const BodyText1(
                              'Movies',
                              style: TextStyle(
                                fontSize: 10,
                              ),
                            ),
                            onPressed: () {
                              ref.read(appPageProvider.notifier).state = 1;
                            },
                          ),
                          const SizedBox(width: 5),
                          TextButton(
                            focusNode: menufocus[3],
                            style: ButtonStyle(
                                backgroundColor: WidgetStatePropertyAll(
                                    AppColors.purple
                                        .withAlpha(page == 2 ? 80 : 0))),
                            child: const BodyText1(
                              'TV Shows',
                              style: TextStyle(fontSize: 10),
                            ),
                            onPressed: () {
                              ref.read(appPageProvider.notifier).state = 2;
                            },
                          ),
                          IconButton(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 0, vertical: 5),
                            focusColor: Colors.white.withAlpha(40),
                            splashRadius: 20,
                            focusNode: menufocus[0],
                            icon: const Icon(FontAwesomeIcons.gear,
                                size: 10, color: Colors.white),
                            onPressed: () =>
                                Scaffold.of(context).openEndDrawer(),
                          ),
                          const SizedBox(width: 20)
                        ],
                      ),
                    );
                  },
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
                      const RefreshNotification(),
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}

class AppBackground extends HookConsumerWidget {
  const AppBackground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final item = ref.watch(selectedItemProvider);
    final background = item.tmdb?.backdropBig ?? "";
    final controller =
        useAnimationController(duration: const Duration(milliseconds: 300));
    controller.animateTo(1);
    final animation = useAnimation(controller);
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return child!.animate().blurXY(begin: animation, end: 0);
      },
      child: background.isEmpty
          ? Container(
              height: double.infinity,
              width: double.infinity,
              color: AppColors.darkGray,
            )
          : Stack(children: <Widget>[
              SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: CachedNetworkImage(
                  imageUrl: background,
                  fit: BoxFit.fitWidth,
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
                      AppColors.darkGray,
                      AppColors.darkGray.withAlpha(50),
                      AppColors.darkGray.withAlpha(150),
                      AppColors.darkGray,
                      AppColors.darkGray,

                      // AppColors.darkGray.withAlpha(250),
                    ])),
              ),
              // Padding(
              //   padding: const EdgeInsets.only(top: 70.0, left: 20),
              //   child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         Headline3(
              //           item.title,
              //           textAlign: TextAlign.start,
              //         ),
              //         BodyText1(
              //           item.tagline,
              //           textAlign: TextAlign.start,
              //         ),
              //       ]),
              // )
            ]),
    );
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
