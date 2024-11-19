import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:helpers/helpers.dart';
import 'package:helpers/helpers/widgets/text.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:infinite_carousel/infinite_carousel.dart';
import 'package:odin/controllers/app_controller.dart';
import 'package:odin/data/models/item_model.dart';
import 'package:odin/theme.dart';
import 'package:odin/ui/cover/backdrop_cover.dart';
import 'package:odin/ui/cover/poster_cover.dart';
import 'package:odin/ui/detail/detail.dart';
import 'package:odin/ui/widgets/carousel.dart';

import '../../data/entities/trakt.dart';

class Section extends HookConsumerWidget {
  final SectionItem e;
  final Function? lastItemReached;
  const Section({Key? key, required this.e, this.lastItemReached})
      : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    if (ref.watch(itemsProvider(e.url).notifier).page == 0) {
      ref.watch(itemsProvider(e.url).notifier).init(e.url);
    }
    List<Trakt> items = ref.watch(itemsProvider(e.url));

    if (e.filterWatched) {
      items = items.where((element) => element.watched == false).toList();
    }
    final controller = useState(InfiniteScrollController());
    final fn = useFocusNode();
    final dur = useState(300);
    final dir = useState("");
    double extent = e.big ? 220 : 90;

    return Column(
      children: [
        const SizedBox(height: 20),
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            // margin: const EdgeInsets.only(bottom: 40),
            alignment: Alignment.topLeft,
            child: Headline4(
              e.title,
              textAlign: TextAlign.left,
            )),
        const SizedBox(height: 15),
        items.isEmpty
            ? Container(
                height: extent,
                padding: const EdgeInsets.all(20),
                alignment: Alignment.topLeft,
                child: CaptionText(
                  'Getting items...',
                  style: TextStyle(color: AppColors.gray2),
                ),
              )
            : Container(
                transform: Matrix4.translationValues(0, -10, 0),
                height: 180,
                width: double.infinity,
                child: OdinCarousel(
                    itemBuilder: (context, itemIndex, realIndex, controller) {
                      final currentOffset = extent * realIndex;
                      const maxScale = 1;
                      const fallOff = 0.2;
                      const minScale = 0.85;
                      return AnimatedBuilder(
                        animation: controller,
                        builder: (context, child) {
                          final diff = (controller.offset - currentOffset);

                          final carouselRatio = extent / fallOff;
                          double r = (maxScale - (diff / carouselRatio));
                          double s = (maxScale - (diff / carouselRatio).abs());

                          double f = s;
                          double b = s;
                          if (s < minScale) {
                            s = minScale;
                          }

                          if (f < 0.3) {
                            f = 0.3;
                          }

                          if (b < 0.2) {
                            b = 0.2;
                          }

                          return child!
                              .animate()
                              .blurXY(end: 0, begin: 5)
                              .fade(end: f)
                              .blurXY(end: 1.3 - (1.3 * b))
                              // .flipH(end: 1.5 - (1.5 * s))
                              .scaleXY(end: s, curve: Curves.easeInOutExpo);
                        },
                        child: e.big
                            ? BackdropCover(items[itemIndex])
                            : PosterCover(items[itemIndex]),
                      );
                    },
                    extent: extent,
                    keys: const [
                      PhysicalKeyboardKey.arrowLeft,
                      PhysicalKeyboardKey.arrowRight
                    ],
                    count: items.length,
                    axis: Axis.horizontal),
              )
        // : KeyboardListener(
        //     focusNode: fn,
        //     onKeyEvent: (KeyEvent keyEvent) {
        //       if (keyEvent is KeyUpEvent) {
        //         dur.value = 300;
        //         return;
        //       }

        //       if (![
        //         PhysicalKeyboardKey.arrowLeft,
        //         PhysicalKeyboardKey.arrowRight,
        //         PhysicalKeyboardKey.enter
        //       ].contains(keyEvent.physicalKey)) {
        //         return;
        //       }

        //       if (keyEvent.physicalKey == PhysicalKeyboardKey.enter) {
        //         final item = ref.read(selectedItemProvider);
        //         Navigator.of(context).push(MaterialPageRoute(
        //             builder: (context) => Detail(
        //                   item: item.show != null ? item.show! : item,
        //                 )));
        //       }

        //       if (keyEvent.logicalKey == LogicalKeyboardKey.arrowRight) {
        //         if (dir.value != "next") {
        //           dur.value = 300;
        //           dir.value = "next";
        //         }

        //         if (controller.value.offset >=
        //             (items.length - 1) * extent) {
        //           return;
        //         }
        //         controller.value.nextItem(
        //             duration: Duration(milliseconds: dur.value),
        //             curve: Curves.linearToEaseOut);
        //       }
        //       if (keyEvent.logicalKey == LogicalKeyboardKey.arrowLeft) {
        //         if (dir.value != "prev") {
        //           dur.value = 300;
        //           dir.value = "prev";
        //         }
        //         if (controller.value.offset <= extent) {
        //           return;
        //         }
        //         controller.value.previousItem(
        //             duration: Duration(milliseconds: dur.value),
        //             curve: Curves.linearToEaseOut);
        //       }

        //       dur.value -= 10;
        //       if (dur.value < 100) {
        //         dur.value = 100;
        //       }
        //     },
        //     child: Container(
        //         transform: Matrix4.translationValues(0, -10, 0),
        //         height: 180,
        //         width: double.infinity,
        //         child: InfiniteCarousel.builder(
        //           itemCount: items.length,
        //           itemExtent: extent,
        //           center: false,
        //           anchor: 0.02,
        //           velocityFactor: 0.2,
        //           onIndexChanged: (index) {
        //             ref.read(selectedItemProvider.notifier).state =
        //                 items[index];
        //           },
        //           controller: controller.value,
        //           axisDirection: Axis.horizontal,
        //           loop: false,
        //           scrollBehavior: ScrollConfiguration.of(context).copyWith(
        //             dragDevices: {
        //               // Allows to swipe in web browsers
        //               PointerDeviceKind.touch,
        //               PointerDeviceKind.mouse
        //             },
        //           ),
        //           itemBuilder: (context, itemIndex, realIndex) {
        //             final currentOffset = extent * realIndex;
        //             const maxScale = 1;
        //             const fallOff = 0.2;
        //             const minScale = 0.85;
        //             return AnimatedBuilder(
        //               animation: controller.value,
        //               builder: (context, child) {
        //                 final diff =
        //                     (controller.value.offset - currentOffset);

        //                 final carouselRatio = extent / fallOff;
        //                 double r = (maxScale - (diff / carouselRatio));
        //                 double s =
        //                     (maxScale - (diff / carouselRatio).abs());

        //                 double f = s;
        //                 double b = s;
        //                 if (s < minScale) {
        //                   s = minScale;
        //                 }

        //                 if (f < 0.3) {
        //                   f = 0.3;
        //                 }

        //                 if (b < 0.2) {
        //                   b = 0.2;
        //                 }

        //                 return child!
        //                     .animate()
        //                     .blurXY(end: 0, begin: 5)
        //                     .fade(end: f)
        //                     .blurXY(end: 1.3 - (1.3 * b))
        //                     // .flipH(end: 1.5 - (1.5 * s))
        //                     .scaleXY(end: s, curve: Curves.easeInOutExpo);
        //               },
        //               child: e.big
        //                   ? BackdropCover(items[itemIndex])
        //                   : PosterCover(items[itemIndex]),
        //             );
        //           },
        //         )),
        //   )
      ],
    );
  }
}
